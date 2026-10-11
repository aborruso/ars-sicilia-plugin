# LOG

## 2026-10-11 - prima versione, solo locale

- Repo separato dalla CLI: dentro la CLI il packager del catalogo copierebbe le cartelle del plugin nelle PR.
- Due pezzi: il plugin (skill in italiano) e il bundle `ars-sicilia.mcpb` per Claude Desktop. La chat di Desktop ignora i server locali dichiarati in un plugin, mentre un'estensione `.mcpb` la raggiunge.
- Il server MCP lancia la CLI per eseguire gli strumenti e la cerca prima accanto a sé: il bundle porta entrambi i binari in `bin/`. Verificato in ambiente pulito (`env -i`, HOME vuota, PATH senza la CLI): `ddl_get`, `ddl_iter`, `novita`, `commissioni_sommari`, `leggi_cerca`, `legge_cronologia`, `risoluzioni_cerca`, `ddl_firmatari`, `deputato_profilo` rispondono.
- Cross-compilazione senza cgo (SQLite di modernc). macOS universale con `makefat` (arm64 + x86_64, verificato con `file`); su Windows Desktop aggiunge `.exe` da solo, quindi un solo bundle copre le due piattaforme. 38 MB compresso.
- Superficie MCP più povera della CLI: `leggi_get` senza `anno`, `risoluzioni_get` senza `commissione`, `ddl_cerca` senza `numero`. La skill indirizza alle ricerche che li hanno. Gli strumenti che leggono il database locale (`sql`, `search`, `ddl_drift`, `workflow_status`, `import`) restano fuori: senza sync non c'è database.
- Le viste composte (`ddl_iter`, `legge_cronologia`, `deputato_profilo`, ...) prendono gli argomenti posizionali in un unico campo stringa `args`.
- `claude plugin validate` passa su plugin e marketplace. macOS non provato.
