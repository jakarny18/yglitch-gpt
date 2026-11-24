# Étape 30 — consommation par blocs via le pool

## Ajouts

- `StreamingVoicePool::popBlock()` expose la lecture de blocs préalloués pour chaque voix.
- Le chemin délègue à `StreamingSampleReader::popBlock()` et n'effectue pas d'accès disque ni de verrou.
- En cas d'index de voix invalide, le résultat est nul et les buffers fournis sont remplis de silence.

## Contrat

Les buffers `left` et `right` doivent être alloués par l'appelant avant l'appel audio. Un seul consommateur audio doit lire chaque lecteur.
