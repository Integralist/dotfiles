const assert = require('node:assert/strict')
const fs = require('node:fs')
const os = require('node:os')
const path = require('node:path')
const sumProviderCosts = require('../.config/zsh/pi-copilot-cost.cjs')

const sessions = fs.mkdtempSync(path.join(os.tmpdir(), 'pi-copilot-cost-test-'))
const writeSession = (name, records) => {
	const file = path.join(sessions, 'project', name)
	fs.mkdirSync(path.dirname(file), { recursive: true })
	fs.writeFileSync(file, `${records.map((record) => JSON.stringify(record)).join('\n')}\n`)
}
const assistant = (provider, timestamp, cost) => ({
	type: 'message',
	message: { role: 'assistant', provider, model: 'test-model', timestamp, usage: { cost: { total: cost } } },
})
const inMonth = new Date(2026, 9, 20, 12).toISOString()
const beforeMonth = new Date(2026, 8, 30, 23).toISOString()
const afterRange = new Date(2026, 9, 21, 0).toISOString()
const userMessage = assistant('github-copilot', inMonth, 8)
userMessage.message.role = 'user'

async function main() {
	try {
		writeSession('usage.jsonl', [
			assistant('github-copilot', inMonth, 1.25),
			assistant('google-vertex', inMonth, 10),
			assistant('github-copilot', beforeMonth, 2),
			assistant('github-copilot', afterRange, 4),
			userMessage,
			assistant('github-copilot', inMonth, 0.5),
		])

		const copilotTotal = await sumProviderCosts(sessions, 'github-copilot', '2026-10-01', '2026-10-20')
		assert.equal(copilotTotal, 1.75)
		assert.equal(await sumProviderCosts(sessions, 'amazon-bedrock', '2026-10-01', '2026-10-20'), 0)
		await assert.rejects(sumProviderCosts(sessions, 'github-copilot', 'not-a-date', '2026-10-20'), /YYYY-MM-DD/)
		console.log('PASS  Pi provider costs are filtered by provider and local date range')
	} finally {
		fs.rmSync(sessions, { recursive: true, force: true })
	}
}

main().catch((error) => {
	console.error(error)
	process.exitCode = 1
})
