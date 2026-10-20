const fs = require('node:fs')
const path = require('node:path')
const readline = require('node:readline')

function parseLocalDate(value, endOfDay = false) {
	const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(value)
	if (!match) throw new Error(`expected date in YYYY-MM-DD format: ${value}`)

	const [, year, month, day] = match.map(Number)
	const date = endOfDay
		? new Date(year, month - 1, day, 23, 59, 59, 999)
		: new Date(year, month - 1, day)
	if (date.getFullYear() !== year || date.getMonth() !== month - 1 || date.getDate() !== day) {
		throw new Error(`invalid calendar date: ${value}`)
	}
	return date
}

async function sumProviderCosts(sessionsDir, provider, since, until) {
	if (typeof provider !== 'string' || provider.length === 0) {
		throw new Error('provider is required')
	}
	const start = parseLocalDate(since)
	const end = parseLocalDate(until, true)
	if (start > end) throw new Error('since date must not be after until date')

	let total = 0
	async function scan(directory) {
		const entries = await fs.promises.readdir(directory, { withFileTypes: true })
		for (const entry of entries) {
			const file = path.join(directory, entry.name)
			if (entry.isDirectory()) {
				await scan(file)
				continue
			}
			if (!entry.isFile() || path.extname(entry.name) !== '.jsonl') continue

			// Pi session logs are append-only, so older files cannot contain new usage.
			const stat = await fs.promises.stat(file)
			if (stat.mtimeMs < start.getTime()) continue

			const lines = readline.createInterface({
				input: fs.createReadStream(file, { encoding: 'utf8' }),
				crlfDelay: Infinity,
			})
			let lineNumber = 0
			for await (const line of lines) {
				lineNumber++
				if (line.length === 0) continue

				let record
				try {
					record = JSON.parse(line)
				} catch {
					throw new Error(`invalid JSON in Pi session ${path.basename(file)} at line ${lineNumber}`)
				}
				const message = record?.message
				if (record?.type !== 'message' || message?.role !== 'assistant' || message?.provider !== provider) continue

				const timestamp = new Date(message.timestamp)
				if (!Number.isFinite(timestamp.getTime())) {
					throw new Error(`invalid timestamp in Pi session ${path.basename(file)} at line ${lineNumber}`)
				}
				if (timestamp < start || timestamp > end) continue

				const cost = Number(message.usage?.cost?.total)
				if (!Number.isFinite(cost)) {
					throw new Error(`missing numeric cost in Pi session ${path.basename(file)} at line ${lineNumber}`)
				}
				total += cost
			}
		}
	}

	await scan(sessionsDir)
	return total
}

async function main() {
	const [sessionsDir, since, until] = process.argv.slice(2)
	if (!sessionsDir || !since || !until) {
		throw new Error('usage: pi-copilot-cost.cjs <sessions-dir> <since> <until>')
	}
	const total = await sumProviderCosts(sessionsDir, 'github-copilot', since, until)
	process.stdout.write(`${total}\n`)
}

if (require.main === module) {
	main().catch((error) => {
		console.error(`pi-copilot-cost: ${error.message}`)
		process.exitCode = 1
	})
}

module.exports = sumProviderCosts
