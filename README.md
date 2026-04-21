# citymall-prototype
🛍️ CityMall prototype — connecting merchants, customers &amp; riders locally. Full production versions coming soon.

# 🛍️ CityMall — Prototipo

> ⚠️ **Questo repository contiene il prototipo funzionale di CityMall.**
> È stato sviluppato per validare i flussi core e il modello dati del sistema.
> Le versioni ufficiali di produzione sono attualmente in fase di sviluppo attivo — vedi sezione [Roadmap](#-roadmap-versioni-di-produzione).

---

## Cos'è CityMall

CityMall è un ecosistema di shopping locale cross-platform che connette tre tipologie di utenti:

- 🏪 **Merchant** — commercianti che gestiscono uno o più negozi fisici, pubblicano prodotti e gestiscono gli ordini in entrata
- 🛒 **Customer** — clienti che scoprono negozi vicini,confrontano offerte e prodotti, aggiungono prodotti al carrello e tracciano le consegne in tempo reale
- 🛵 **Rider** — fattorini che accettano le consegne e aggiornano la propria posizione live

Il prototipo è stato sviluppato con **Flutter** per il frontend mobile e **Supabase** come backend (database PostgreSQL + Auth + Storage + Realtime).

---

## ⚠️ Limiti del Prototipo

Questo progetto nasce come proof-of-concept per validare il modello dati e i flussi principali. Non rispetta un'architettura a strati formale ed è stato sviluppato per muoversi velocemente.

Limitazioni note:
- Nessuna separazione netta tra layer (data / domain / presentation)
- Gestione degli errori minima
- Nessuna suite di test
- Non ottimizzato per ambienti di produzione

---

## Stack Tecnologico

| Layer | Tecnologia |
|---|---|
| Mobile (iOS & Android) | Flutter |
| Backend / Database | Supabase (PostgreSQL 17) |
| Autenticazione | Supabase Auth |
| Geolocalizzazione | PostGIS (geography type) |
| Realtime | Supabase Realtime (tracking rider) |
| Storage | Supabase Storage (foto prodotti, negozi, profili) |

---

## Modello Dati

Il database ha un totale di 30 tabelle. Tutte le tabelle hanno Row Level Security (RLS) abilitata.

### 👤 Utenti & Autenticazione

| Tabella | Descrizione |
|---|---|
| `users` | Utente base con ruolo (`customers`, `merchants`, `riders`). Collegato a `auth.users` di Supabase |
| `contacts` | Email e telefono per ogni utente, con flag `is_default` |
| `profile_photos` | URL foto profilo, condivisa tra customers, merchants e riders |

### 🙋 Ruoli Utente

| Tabella | Descrizione |
|---|---|
| `customers` | Cliente con nome, cognome, riferimento a foto profilo |
| `merchants` | Commerciante con nome, cognome e partita IVA (`vat_number`) |
| `riders` | Fattorino con tipo veicolo, targa e stato live (`offline` default) |

### 📍 Indirizzi

| Tabella | Descrizione |
|---|---|
| `address_customers` | Indirizzi del cliente con coordinate `lat/lng` e campo `geography` PostGIS |
| `address_merchants` | Indirizzo del merchant |
| `address_stores` | Indirizzo fisico del negozio con campo `geography` PostGIS per ricerca per prossimità |

### 🏪 Negozi

| Tabella | Descrizione |
|---|---|
| `stores` | Negozio appartenente a un merchant, con categoria e indirizzo |
| `store_photos` | Foto del negozio (primaria + galleria) |
| `store_contacts` | Telefono, email, sito web e orari di apertura del negozio |
| `store_categories` | Relazione many-to-many tra negozi e categorie |

### 📦 Catalogo Prodotti

| Tabella | Descrizione |
|---|---|
| `categories` | Categorie ad albero (self-referencing tramite `parent_id`) |
| `products` | Prodotto con nome, descrizione e immagine principale |
| `product_variants` | Variante del prodotto (SKU, barcode, prezzo, stock, foto) |
| `variant_photos` | Galleria foto per ogni variante |
| `attributes` | Attributi generici (es. Colore, Taglia) |
| `variant_attribute_values` | Valori degli attributi per ogni variante |

### 📋 Inventario Negozio (in sviluppo)

| Tabella | Descrizione |
|---|---|
| `store_products` | Associazione prodotto-negozio con flag `is_active` |
| `store_inventory` | Inventario per negozio: quantità, prezzo acquisto/vendita, sconto, stato (`deposito` → `in_revisione` → `pubblicato`) |
| `store_inventory_attributes` | Attributi specifici per ogni item di inventario |

### 🛒 Carrello & Ordini

| Tabella | Descrizione |
|---|---|
| `carts` | Carrello del cliente con flag `isNow` |
| `cart_items` | Item nel carrello: variante, quantità, prezzo unitario, subtotale |
| `orders` | Ordine con stato, totale e costo di consegna |
| `order_items` | Item dell'ordine: variante, negozio, rider assegnato, stato item, motivo rifiuto |
| `invoices` | Fattura associata all'ordine: numero, PDF, importo tasse |

### 🛵 Rider & Tracking

| Tabella | Descrizione |
|---|---|
| `active_riders` | Rider attivi con stato (`Available`) e ultima posizione (`lat/lng`) |
| `rider_live_tracking` | Tracciamento in tempo reale: posizione corrente, ordine associato, indirizzo negozio e cliente |

### 💡 Engagement & Analytics

| Tabella | Descrizione |
|---|---|
| `wishlist` | Lista desideri cliente (prodotto + customer) |
| `user_interactions` | Interazioni cliente con prodotti e negozi (per raccomandazioni future) |
| `search_history` | Storico ricerche con query e posizione geografica al momento della ricerca |

---

## 🚧 Roadmap — Versioni di Produzione

Sulla base dell'esperienza acquisita con questo prototipo, sono in sviluppo due app dedicate con architettura di produzione:

| App | Descrizione | Stato |
|---|---|---|
| **CityMall User App** | App per clienti — scoperta negozi, ordini, tracking | 🚧 In sviluppo |
| **CityMall Management** | Dashboard per merchant e rider | 🚧 In sviluppo |

### Architettura delle versioni di produzione

Entrambe le app seguiranno:

```
lib/
├── core/
│   ├── di/               # GetIt — service locator
│   ├── router/           # GoRouter — navigazione dichiarativa
│   ├── theme/            # Design system (colori, typography)
│   └── error/            # Failure classes, Error class
├── features/
│   ├── auth/
│   │   ├── data/         # Datasources, models, repository impl
│   │   ├── domain/       # Entities, repository abstract, use cases
│   │   └── presentation/ # Pages, BLoCs, widgets
│   ├── store/
│   ├── cart/
│   └── order/
└── main.dart
```

**Stack confermato:** Flutter · Clean Architecture · BLoC · GoRouter · GetIt · Supabase

---

## Avvio del Prototipo





## Stato del Progetto

| Elemento | Stato |
|
| Modello dati | ✅ Definito e completo |
| Autenticazione con ruoli | ✅ Funzionante |  nel prototipo solo ruolo user 
| Flusso carrello → ordine | ✅ Implementato |
| Tracking rider realtime | ❌ Pnon presenti nel prototipo  |
| Architettura produzione | 🚧 In sviluppo |
| Test | ❌ Non presenti nel prototipo |

---

> Sviluppato da Alessandro —studente della facoltà di  Ingegneria Informatica Unisa, 

