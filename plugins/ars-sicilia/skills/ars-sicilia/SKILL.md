---
name: ars-sicilia
description: Cerca e ricostruisce gli atti dell'Assemblea Regionale Siciliana (ARS) dal portale ufficiale dati.ars.sicilia.it. Usala quando l'utente chiede di un disegno di legge siciliano e del suo iter, di una legge regionale e di come ci si è arrivati, di interrogazioni, interpellanze, mozioni, ordini del giorno o risoluzioni, di una seduta d'aula o di commissione, dell'attività di un deputato regionale o di un gruppo parlamentare, oppure quando parte da una notizia sull'ARS e vuole verificarla sui documenti.
---

# Atti dell'Assemblea Regionale Siciliana

Questa skill usa gli strumenti MCP del server **ars-sicilia** (estensione `ars-sicilia.mcpb` di Claude Desktop). Ogni strumento interroga dal vivo il portale dati.ars.sicilia.it: dati pubblici, nessun account.

Se gli strumenti `ddl_get`, `ddl_iter` e gli altri qui sotto non sono disponibili, il server non è installato: dillo all'utente e rimandalo all'installazione dell'estensione. Non rispondere a memoria su atti, numeri e date.

## Come si chiamano gli strumenti

Due famiglie, con due modi di passare gli argomenti:

- **ricerche e schede** (`*_cerca`, `*_get`, `commissioni_sommari`, `commissioni_convocazioni`, `novita`, `gruppi_elenco`): parametri con nome, per esempio `ddl_get` con `legisl: 18, numero: 1018`.
- **viste composte** (`ddl_iter`, `ddl_stralci`, `legge_cronologia`, `deputato_profilo`, `commissione_dossier`, `gruppi_get`): gli argomenti posizionali vanno tutti in un unico campo stringa `args`, separati da spazio. `ddl_iter` con `args: "18 1200"`; `deputato_profilo` con `args: "Abbate Ignazio", legisl: 18`. Il parametro `select` restringe i campi (`"data,fase,sede,seduta,titolo"`).

La legislatura corrente è la **XVIII** (`legisl: 18`, dal 2022). La XVII copre il 2017-2022.

## Leggere le risposte

- Le risposte possono portare **`avvisi`**, **`nota`**, **`hint`** o **`troncato`**. Leggili sempre prima di concludere: dicono se il risultato è parziale, quale documento è stato aperto fra più candidati, o perché una ricerca è vuota.
- **Una ricerca vuota non prova che l'atto non esista.** Il portale pubblica in ritardo, e il ritardo cambia da archivio ad archivio (da pochi giorni a quasi due mesi). Per una notizia recente chiama `novita` (per esempio `since: "30d"`, `archivi: "ddl,resoconti"`): dice fin dove arriva ogni archivio.
- **"Il backend non ha risposto" è un guasto temporaneo**, non un'assenza: riprova, restringendo la ricerca.
- `troncato: true` vuol dire che ci sono altri risultati oltre quelli mostrati: alza `limit` o restringi prima di dire che qualcosa manca.
- Per citare un atto usa **`permalink`** o `docno` della scheda. Il campo `url` degli archivi di atti non è stabile e non va riportato; quello di resoconti e sommari invece sì.
- Ogni data ha accanto **`data_iso`** (`AAAA-MM-GG`): usala per ordinare e confrontare.

## Percorsi principali

### Da una notizia a un disegno di legge

1. Se la notizia dà il numero: `ddl_get` (`legisl`, `numero`), poi `ddl_iter` (`args: "18 <numero>"`).
2. Se dà solo l'argomento: `ddl_cerca` con `frase` (la locuzione esatta, per esempio `"aree idonee"`) e `anno`. `testo` cerca le parole in qualunque punto del documento e porta molto rumore; `frase` è quasi sempre la scelta giusta.
3. Se dà la data di una seduta di commissione ma non il numero dell'atto: `commissioni_sommari` con `legisl` e `data` (`"2024-09-17"`). Il sommario nomina i disegni di legge esaminati quel giorno.

In `ddl_iter` tieni sempre `titolo` fra i campi: dice cosa è successo, mentre `data`, `fase`, `sede` e `seduta` dicono solo quando e dove. La data di un articolo di giornale è di solito il giorno dopo la seduta.

### Da una legge regionale a come ci si è arrivati

`legge_cronologia` con `args: "<legisl> <numero>"` e **sempre `anno`**: lo stesso numero di legge si ripete ogni anno (nella XVIII ci sono due L.R. 26). Il campo `ddl_originari` dà i disegni di legge da cui la legge nasce, da passare a `ddl_iter`.

Per la scheda di una legge usa `leggi_cerca` con `legisl`, `numero` e `anno`. `leggi_get` non accetta l'anno e può aprire la legge omonima di un altro anno: se lo usi, controlla la data nella risposta.

### Sedute d'aula e di commissione

- Aula: `resoconti_cerca` (`legisl` con `data`, `numero` o `oratore`), poi `resoconti_get` per la scheda, con il PDF del resoconto stenografico (`pdf_url`), chi ha presieduto e chi ha parlato. Una seduta che dura più giorni (le finanziarie) è archiviata al giorno di apertura: se la ricerca per data del voto è vuota, cerca per numero di seduta.
- Commissioni: `commissioni_sommari` e `commissioni_convocazioni`. **Il numero di seduta riparte in ogni commissione**: con `numero` passa sempre anche `commissione` (`"SECONDA"`, `"Bilancio"`) o `codcom` (1-6). `ddl_iter` riporta la commissione nel campo `sede` accanto al numero della seduta.
- Su questi archivi restringi sempre (numero, poi anno, poi commissione): le risposte grandi arrivano troncate.

### Atti ispettivi e di indirizzo

`interrogazioni_cerca`, `interpellanze_cerca`, `mozioni_cerca`, `odg_cerca`, `risoluzioni_cerca`, con i rispettivi `*_get`.

- Per un atto di cui conosci il numero usa `numero`, non `testo`: col testo arrivano tutti i documenti che citano quel numero.
- **Le risoluzioni sono numerate per commissione** (1/I, 1/II): lo stesso numero indica atti diversi. Usa `risoluzioni_cerca` con `numero` e `commissione` (`"PRIMA"`..`"SESTA"` o una parola della denominazione; la sigla romana `"I"` non trova nulla).
- `firmatario` vuole il nome come lo scrive il portale: `ddl_firmatari` con `legisl` e `search` lo trova.

### Deputati, gruppi, commissioni

- `deputato_profilo` (`args: "<Cognome Nome>"`, `legisl`, eventuale `data` come intervallo `"2026-01-01:2026-06-30"`): tutti gli atti firmati e gli interventi. Leggi `non_raggiunti` prima dei conteggi: gli archivi che non hanno risposto non sono contati.
- `gruppi_elenco` (con `deputato` dice in quale gruppo sta un parlamentare) e `gruppi_get` (`args: "<nome o slug del gruppo>"`).
- `commissione_dossier` (`args: "SESTA"`, `legisl`): convocazioni, sommari, ddl assegnati e pareri. Le commissioni speciali si chiamano con la denominazione d'archivio, non con il nome d'uso ("Antimafia" non trova nulla).

### Cosa è nuovo

`novita` con `since` (`"7d"`, `"2m"`: `m` sono mesi) o `dal` (`"2026-07-01"`), ed eventuale `archivi`. Accanto a ogni archivio c'è il ritardo di pubblicazione della fonte.

## Filtri che non si indovinano

`materia` e `firmatario` di `ddl_cerca` vogliono i valori esatti del portale: un valore inventato restituisce zero risultati, che sembra un'assenza. Chiedili prima con `ddl_materie` e `ddl_firmatari`. Il tipo di iniziativa (Governativa, Parlamentare, Popolare) si passa in `firmatario`: l'elenco è in `ddl_iniziative`.

## Cosa questa skill non copre

Il portale non pubblica voti nominali, presenze in aula, emendamenti come archivio né spese dell'Assemblea: dillo invece di cercarli. L'esito di una votazione si trova solo nel testo dei resoconti.

Gli strumenti `sql`, `search`, `ddl_drift`, `workflow_status`, `import` e le classifiche di `analytics` basate sul database locale richiedono una sincronizzazione che questa installazione non fa: non usarli.
