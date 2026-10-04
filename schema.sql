-- Schema per il gestionale gratta e vinci su Supabase
-- Da eseguire una sola volta in: Supabase → SQL Editor → New query → Run
--
-- Hai già creato le tabelle con una versione precedente di questo file?
-- Esegui prima queste righe di aggiornamento (sono sicure, non toccano i dati
-- del magazzino né le operazioni), poi il resto dello schema sotto:
--
--   alter table gv_operations add column if not exists ora text;
--   alter table gv_operations add column if not exists ts bigint;
--   drop table if exists gv_archivio;
--   (gv_archivio si ricostruisce da solo: basta premere di nuovo
--    "Salva su Supabase adesso" dall'app dopo aver creato la tabella nuova)

create table if not exists gv_games (
  nome text primary key,
  prezzo numeric not null,
  giacenza integer not null,
  colore text,
  immagine text,
  ordine integer
);

create table if not exists gv_operations (
  id text primary key,
  data date not null,
  ora text,
  ts bigint,
  tipo text not null,
  gioco text,
  quantita integer default 0,
  importo numeric default 0,
  importo_vinto numeric,
  schede jsonb default '[]'::jsonb,
  note text,
  created_at timestamptz default now()
);

create table if not exists gv_settings (
  key text primary key,
  value text
);

create table if not exists gv_archivio (
  data date not null,
  turno text not null,
  pezzi integer,
  incasso_vendite numeric,
  pagamenti numeric,
  cassa_netta numeric,
  num_operazioni integer,
  primary key (data, turno)
);

-- Row Level Security: per semplicità, l'app usa la chiave "anon" pubblica
-- e accede liberamente a queste 4 tabelle. Non ci sono altri dati sensibili
-- dentro lo stesso progetto Supabase, quindi va bene così.
-- Se in futuro aggiungi altre tabelle con dati più delicati, dagli regole
-- di accesso diverse da queste.

alter table gv_games enable row level security;
alter table gv_operations enable row level security;
alter table gv_settings enable row level security;
alter table gv_archivio enable row level security;

create policy "anon full access" on gv_games for all using (true) with check (true);
create policy "anon full access" on gv_operations for all using (true) with check (true);
create policy "anon full access" on gv_settings for all using (true) with check (true);
create policy "anon full access" on gv_archivio for all using (true) with check (true);
