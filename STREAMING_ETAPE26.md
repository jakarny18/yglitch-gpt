# Étape 26 — Pool de lecteurs indépendants pour voix simultanées

## Ajout

- Nouveau `StreamingVoicePool` de taille fixe (4 voix).
- Chaque voix possède son propre `StreamingSampleReader`, donc son propre curseur de lecture et son propre ring buffer.
- `open()` prépare les quatre lecteurs depuis un thread non audio.
- `popSample()` lit une voix donnée sans verrou, allocation ni accès disque côté audio.
- En cas d'échec d'ouverture d'un lecteur, les lecteurs déjà ouverts sont fermés.

## Limites à connaître

Cette étape fournit l'infrastructure de lecture multi-voix, mais ne remplace pas encore les buffers du sampler dans `PluginProcessor::trigger()` / `renderVoice()`. Le séquenceur et les voix actuelles continuent donc d'utiliser les samples décodés en RAM. Le pool doit être raccordé à la sélection de slot et aux événements de déclenchement dans une étape suivante.

Le pool ouvre quatre lecteurs distincts du même fichier, ce qui multiplie le travail de décodage et la taille mémoire des rings (environ 2 Mio par lecteur stéréo, soit environ 8 Mio par pool, hors buffers de décodage). Le test de charge et la mesure des underruns restent à faire.

## Validation

Vérification structurelle uniquement : présence des quatre lecteurs, API audio sans verrou/allocation explicite et inclusion des nouveaux fichiers dans CMake. Aucune compilation JUCE/VST3 ni validation audio Windows n'a été exécutée dans cet environnement.
