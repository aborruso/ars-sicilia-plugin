# Plugin ARS Sicilia per Claude, con bundle MCPB

Due pezzi che si installano separatamente, perché la chat di Claude Desktop non avvia i server locali dichiarati in un plugin:

- **il plugin**: la skill in italiano, installabile da Customize > Plugins (chat, Cowork) e da Claude Code;
- **il bundle `ars-sicilia.mcpb`**: il server MCP con i binari dentro, doppio clic in Claude Desktop, senza Go.

Fonti: claude.com/docs/plugins/build, /plugins/platform-support, /connectors/building/mcpb; specifica MCPB (`modelcontextprotocol/mcpb`, MANIFEST.md).

Decisioni prese: repo separato, italiano, prima solo locale, bundle incluso.

## Fase 1 - bundle MCPB

- [ ] `scripts/build-mcpb.sh`: compila `ars-sicilia-pp-mcp` dal sorgente della CLI per `windows/amd64`, `darwin/arm64` e `darwin/amd64`, unisce i due macOS in un binario universale, scrive il manifest e impacchetta con `npx @anthropic-ai/mcpb pack` → verifica: `mcpb validate` sul manifest, `unzip -l` mostra `bin/ars-sicilia-pp-mcp` e `bin/ars-sicilia-pp-mcp.exe`.
- [ ] `mcpb/manifest.json` dal manifest generato della CLI: `version` della CLI, `author` reale, `platforms` solo `darwin` e `win32`, `repository` e `homepage` → verifica: `mcpb validate`.
- [ ] Prova su Windows: installazione del `.mcpb` in Claude Desktop, gli strumenti compaiono nella chat, una domanda reale → verifica: risposta con dati dal portale.
- [ ] macOS: non provabile da qui; dichiararlo nel README finché qualcuno non lo prova.

## Fase 2 - plugin

- [ ] `.claude-plugin/marketplace.json` alla radice e `plugins/ars-sicilia/.claude-plugin/plugin.json` → verifica: `claude plugin validate`.
- [ ] `plugins/ars-sicilia/skills/ars-sicilia/SKILL.md` sugli strumenti MCP (nomi da `tools/list`), in italiano: quando usarla, i percorsi principali, le avvertenze che cambiano le conclusioni → verifica: ogni strumento citato esiste.
- [ ] Niente `.mcp.json` nella v1: il server arriva dal bundle; dichiarare in skill e README cosa fare se gli strumenti mancano → verifica: rilettura.
- [ ] README (italiano, almeno 40 parole: cosa fa, come si installa, quali dati invia) e LICENSE Apache-2.0 come la CLI → verifica: conteggio parole.

## Fase 3 - prova

- [ ] Claude Code: `claude --plugin-dir plugins/ars-sicilia` con il server MCP già configurato, tre domande dal report 2026-10-11 → verifica: strumenti giusti, numeri riportati.
- [ ] Claude Desktop (Windows): zip del plugin con Upload plugin + bundle installato, stesse domande in chat → verifica: skill caricata e strumenti usati.

## Fase 4 - chiusura

- [ ] LOG.md, `.gitignore` (`dist/`, `build/`), commit locale → verifica: `git status` pulito.
- [ ] Repo pubblico e release con il `.mcpb`: solo su conferma.

## Domande aperte

- serve un `.mcp.json` per chi usa solo Claude Code o Cowork senza il bundle?
- firma del codice: binari non firmati; su macOS da verificare se Claude Desktop li avvia senza intervento.
- Windows arm64 e Linux fuori dalla v1.
