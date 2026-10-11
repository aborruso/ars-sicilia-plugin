# ARS Sicilia per Claude

Porta in Claude gli atti dell'Assemblea Regionale Siciliana: disegni di legge e il loro iter, leggi regionali, interrogazioni, interpellanze, mozioni, ordini del giorno, risoluzioni, resoconti d'aula e lavori delle commissioni. I dati vengono letti dal vivo dal portale ufficiale [dati.ars.sicilia.it](https://dati.ars.sicilia.it/).

Sono due pezzi, da installare entrambi:

- **l'estensione `ars-sicilia.mcpb`**: il server che interroga il portale e dà a Claude gli strumenti per farlo. Gira sul tuo computer;
- **il plugin `ars-sicilia`**: insegna a Claude come usare quegli strumenti, quali percorsi seguire partendo da una notizia o da una legge, e come leggere le risposte senza scambiare un ritardo del portale per un atto inesistente.

Il server è la [CLI ars-sicilia](https://github.com/mvanhorn/printing-press-library/tree/main/library/other/ars-sicilia) del catalogo Printing Press, impacchettata per Claude Desktop.

## Installazione

### 1. L'estensione (Claude Desktop)

Scarica `ars-sicilia.mcpb` e aprilo con un doppio clic, oppure trascinalo nella finestra di Claude Desktop, oppure da **Impostazioni > Estensioni > Impostazioni avanzate > Installa estensione**. Conferma nella schermata che si apre e riavvia Claude Desktop.

Funziona su Windows (x64) e macOS (Apple Silicon e Intel). Non serve installare altro: i programmi sono dentro il file.

### 2. Il plugin

In Claude, **Personalizza > Plugin > Aggiungi**:

- da questo repository come marketplace, con l'indirizzo del repository;
- oppure con **Carica plugin**, scegliendo lo zip della cartella `plugins/ars-sicilia`.

In Claude Code:

```bash
claude plugin marketplace add <owner>/ars-sicilia-plugin
claude plugin install ars-sicilia@ars-sicilia
```

## Uso

Fai la domanda in italiano, come la faresti a una persona:

- «A che punto è il ddl 1018 sugli anziani?»
- «Da quali disegni di legge nasce la legge regionale 26 del 2025?»
- «Cosa ha esaminato la commissione Bilancio il 6 ottobre 2026?»
- «Quali interrogazioni ha presentato Cracolici nell'ultimo mese?»

## Dove funziona

| | Chat di Claude Desktop | Cowork | Claude Code | claude.ai web e mobile |
|---|---|---|---|---|
| skill del plugin | sì | sì | sì | sì |
| strumenti (estensione) | sì | da verificare | con la configurazione MCP | no |

Sul web e sul telefono il server locale non c'è: la skill si carica, ma senza strumenti Claude non può leggere il portale.

## Dati

L'estensione contatta solo i siti dell'ARS (`dati.ars.sicilia.it` e `www.ars.sicilia.it`). Non richiede account, non invia ad altri le tue domande e non conserva nulla fuori dal tuo computer. Sono dati pubblici.

## Limiti noti

- Il portale pubblica con ritardo, diverso per ogni archivio: un atto di pochi giorni fa può non esserci ancora.
- I programmi non sono firmati digitalmente. Su macOS l'estensione non è ancora stata provata.

## Costruire l'estensione

`scripts/build-mcpb.sh [cartella-sorgente-della-cli]` compila server e CLI per Windows e macOS e produce `dist/ars-sicilia.mcpb`. Servono Go, Node.js e il sorgente della CLI.

## Licenza

Apache-2.0, come la CLI da cui nasce.
