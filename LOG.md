# LOG

## 2026-10-11 - prove nell'interfaccia unica e link nelle risposte

- Chat e Cowork ora sono un'unica interfaccia (annuncio Anthropic del 2026-09-16). Prova su Windows: gli strumenti dell'estensione funzionano sia nelle domande brevi sia in un task lungo che crea un Claude Docs (42 `tools/call` al server `ARS Sicilia` tra le 21:04 e le 21:18). La skill si carica se la nomini («Loaded skill ars-sicilia») e poi guida le chiamate: `ddl_get`, `ddl_iter`, `novita`, `commissioni_sommari`, `commissioni_convocazioni`. Non provato: se si attiva da sola, senza essere nominata.
- I log di Claude Desktop stanno in `AppData\Local\Claude\Logs`, non più in `Roaming\Claude\logs`. Non registrano il nome dello strumento chiamato né le skill caricate.
- Skill: nuova sezione «Come presentare la risposta». Nelle prove la colonna Fonte delle tabelle aveva solo etichette e i link stavano tutti in fondo. Ora ogni riga porta il suo link. L'`url` degli eventi di `ddl_iter` (`icaro/doc...jsp?icaQueryId=1`) vale solo per la sessione: si usa il `permalink` di `ddl_get`. L'URL delle convocazioni (`/bd/convocazioni/results/<id>`) contiene l'id del documento ed è stabile: riaperto dopo ore risponde 200 sulla stessa convocazione.
- Prova in Claude Desktop (modalità Auto) con lo zip del plugin aggiornato: ogni riga della tabella ha il suo link nella colonna Fonte (scheda ddl, sommari 126/132/133/137, convocazione 155) e il link «scheda ddl» è il permalink `icaro/default.jsp?icaDB=221&icaQuery=docno(9336)`. Nella risposta precedente, prima della modifica, la colonna aveva solo etichette.

## 2026-10-11 - pubblicato

- Repo pubblico https://github.com/aborruso/ars-sicilia-plugin, release v0.1.0 con `ars-sicilia.mcpb` (estensione, `2026.9.7-local.3911710`) e `ars-sicilia-plugin.zip`.
- Marketplace verificato da GitHub in una configurazione di Claude Code temporanea: `marketplace add aborruso/ars-sicilia-plugin` e `install ars-sicilia@ars-sicilia` riescono, inventario `Skills (1) ars-sicilia`.
- Da rifare quando la PR #2309 sarà mergiata: ricostruire il bundle dalla release del catalogo e pubblicare una v0.1.1.
- Aperta la issue #1 per tracciare l'aggiornamento dopo il merge di mvanhorn/printing-press-library#2309. Annotato anche che `scripts/build-mcpb.sh` aggiunge sempre il suffisso `-local.<sha>`, mentre il commento lo dice condizionale.

## 2026-10-11 - prima versione, solo locale

- Repo separato dalla CLI: dentro la CLI il packager del catalogo copierebbe le cartelle del plugin nelle PR.
- Due pezzi: il plugin (skill in italiano) e il bundle `ars-sicilia.mcpb` per Claude Desktop. La chat di Desktop ignora i server locali dichiarati in un plugin, mentre un'estensione `.mcpb` la raggiunge.
- Il server MCP lancia la CLI per eseguire gli strumenti e la cerca prima accanto a sé: il bundle porta entrambi i binari in `bin/`. Verificato in ambiente pulito (`env -i`, HOME vuota, PATH senza la CLI): `ddl_get`, `ddl_iter`, `novita`, `commissioni_sommari`, `leggi_cerca`, `legge_cronologia`, `risoluzioni_cerca`, `ddl_firmatari`, `deputato_profilo` rispondono.
- Cross-compilazione senza cgo (SQLite di modernc). macOS universale con `makefat` (arm64 + x86_64, verificato con `file`); su Windows Desktop aggiunge `.exe` da solo, quindi un solo bundle copre le due piattaforme. 38 MB compresso.
- Superficie MCP più povera della CLI: `leggi_get` senza `anno`, `risoluzioni_get` senza `commissione`, `ddl_cerca` senza `numero`. La skill indirizza alle ricerche che li hanno. Gli strumenti che leggono il database locale (`sql`, `search`, `ddl_drift`, `workflow_status`, `import`) restano fuori: senza sync non c'è database.
- Le viste composte (`ddl_iter`, `legge_cronologia`, `deputato_profilo`, ...) prendono gli argomenti posizionali in un unico campo stringa `args`.
- `claude plugin validate` passa su plugin e marketplace. macOS non provato.
- Prova in Claude Code (`claude -p --plugin-dir`, server del bundle in versione Linux): sul ddl 1018 chiama `ddl_iter` con `args: "18 1018"` e risponde in 3 turni. Da questa shell va lanciato con `env -u ANTHROPIC_API_KEY`, altrimenti usa una chiave API senza credito.
- Prova su Windows, chat di Claude Desktop: estensione installata da Settings > Extensions > Install Extension (il doppio clic sul `.mcpb` non apre l'installazione: l'estensione del file non è associata a Claude), plugin caricato come zip. Sul ddl 1018 usa lo strumento, rileva che la scheda iter è ferma al 22 aprile e integra dai sommari della VI Commissione le sedute del 30/06 e dell'08/07/2026.
