# YouGlitch SMP 1024 — feuille de route de développement

Cette feuille de route distingue ce qui existe dans le prototype natif des fonctions encore à développer. Les fonctions marquées « à faire » ne sont pas incluses dans cette archive.

## Déjà présent dans le prototype
- Plugin JUCE avec cibles VST3 et Standalone.
- Six pistes audio, séquenceur 1024 pas et 16 pages.
- Paramètres BPM, densité, chaos, swing, mute/solo, volume et panoramique.
- Import de samples par piste, huit slots, pitch, boucle et bornes de lecture.
- Jusqu'à 32 slices régulières ; huit boutons de déclenchement rapide.
- Aperçu waveform avec poignées de début et de fin.
- Sauvegarde de l'état du plugin et des chemins de samples.
- Workflow GitHub Actions Windows x64.

## À développer ensuite

### Sampler
- [ ] Détection automatique des transitoires.
- [ ] Déplacement individuel des marqueurs de slice.
- [ ] Reverse, Gate et One Shot.
- [ ] Enveloppe ADSR par sample.
- [ ] Time-stretch de qualité et synchronisation tempo.
- [ ] Crossfade de boucle et édition non destructive.
- [ ] Banque multi-samples, navigateur et glisser-déposer.

### Séquenceur
- [ ] Probability par pas.
- [ ] Ratchet et micro-timing.
- [ ] Conditions de déclenchement.
- [ ] Longueur indépendante par piste et polyrythmie.
- [ ] Séquenceur euclidien.
- [ ] Chaînage de patterns et enregistrement live.

### Moteur GLITCH
- [ ] Beat Repeat, Buffer Freeze, Tape Stop.
- [ ] Reverse Stutter, Granular, Bit Crusher.
- [ ] Synchronisation tempo, automation et macros live.

### Mixage
- [ ] EQ, compresseur, saturation et filtres résonants.
- [ ] Sends Delay / Reverb, limiteur master et vu-mètres.
- [ ] Export WAV 24 bits et 32-bit float.

### Performance et intégration DAW
- [ ] Pads de performance, scènes et lancement quantifié.
- [ ] MIDI Learn et mapping configurable.
- [ ] Synchronisation transport/tempo avec l'hôte.
- [ ] Automation DAW complète.

### Projet, presets et interface
- [ ] Bibliothèque de presets d'usine et utilisateur.
- [ ] Sauvegarde/chargement de projets autonomes.
- [ ] Reproduction fidèle de l'interface HTML originale.
- [ ] Tests de compatibilité Ableton, FL Studio, Cubase et Reaper.
- [ ] Optimisation CPU, mémoire et stabilité audio.

## Critère de validation
Chaque grande fonction doit être compilée, testée dans le standalone, puis testée dans au moins un hôte VST3 avant d'être déclarée terminée. La compilation GitHub seule ne garantit pas la qualité audio ni la compatibilité hôte.

- [x] Lecture inversée du sample et enveloppe ADSR de lecture par piste (étape 9)
- [ ] Mode Gate avec relâchement piloté par Note-Off / durée de pas
- [ ] Crossfade de boucle et lecture sans clic
- [ ] Time-stretch indépendant du pitch

- [x] Mode MIDI Gate avec Note-On / Note-Off et Release (étape 10)
- [ ] Mapping MIDI personnalisable et apprentissage MIDI Learn
- [ ] Gate synchronisé à la longueur des pas du séquenceur

- [x] MIDI Learn CC pour BPM, macros, Master FX et volumes de pistes (étape 11)
- [ ] Courbes de réponse CC, inversion et plage min/max par assignation
- [ ] MIDI Learn pour mute/solo, paramètres de sampler et effets individuels

- [x] Plages CC min/max et inversion individuelle par cible (étape 12)
- [ ] Courbes CC logarithmiques/exponentielles et lissage anti-sauts
- [ ] MIDI Learn pour mute/solo, paramètres sampler et effets individuels

- [x] Courbes de réponse MIDI CC linéaire, exponentielle et logarithmique (étape 13)
- [ ] Tension de courbe et lissage temporel des contrôleurs
- [ ] MIDI Learn pour mute/solo, sampler et effets individuels

- [x] FREEZE, STUTTER, BITCRUSH et TAPE STOP de base pilotés par la lane GLITCH (étape 14)
- [ ] Synchronisation des durées GLITCH au BPM et contrôles de mix par effet
- [ ] Crossfade anti-clic, buffer freeze granulaire et paramètres dédiés par effet


## Étape 15 — Bibliothèque de samples étendue

- Capacité configurée : **300 emplacements par piste**, soit **1 800 emplacements** sur les six pistes.
- Le sélecteur de samples propose les 300 emplacements de la piste active.
- Les fichiers audio sont décodés en mémoire lors de leur chargement. La capacité en nombre d’emplacements ne garantit donc pas que 1 800 gros fichiers puissent tenir simultanément en RAM.
- Le streaming disque et le chargement réellement à la demande restent des améliorations à réaliser pour les très grandes bibliothèques.
- Compilation et tests audio Windows non effectués dans cet environnement.


## Étape 16 — navigateur de samples
- Recherche textuelle parmi les samples chargés sur la piste active.
- Affichage du compteur de samples chargés sur 300.
- Préécoute via le déclenchement de la première slice du sample sélectionné.
- La recherche sélectionne le premier résultat correspondant.


## Étape 17 — navigateur enrichi
- [x] Filtre de catégories par mots-clés du nom de fichier.
- [x] Favoris et affichage des favoris seuls.
- [ ] Persistance des favoris dans l'état du plugin.
- [ ] Catégories personnalisables et étiquettes par sample.
- [ ] Préécoute indépendante sans déclencher le séquenceur.

## Étape 18 — stabilisation audio (première passe)

- [x] Déporter la remise à zéro des voix/du transport dans le thread audio lors des commandes PLAY/STOP, au lieu de modifier les voix directement depuis l'interface.
- [x] Ajouter une demande atomique de reset consommée par `processBlock`.
- [x] Tenter la configuration CMake locale.
- [ ] Compiler VST3 et Standalone sous Windows x64 avec Visual Studio 2022.
- [ ] Audit complet des accès concurrents (pattern, probability, ratchet, micro-shift, sample metadata et sauvegarde/restauration).
- [ ] Tests audio réels : PLAY/STOP, MIDI, changement de sample, boucles, GLITCH, buffers et fréquences d'échantillonnage.
- [ ] Tests de charge CPU/RAM et session longue.

**Résultat de validation de l'étape 18 :** la configuration CMake n'a pas pu récupérer JUCE 8.0.6, car l'environnement n'a pas accès au DNS de `github.com`. Le code n'est donc pas compilé dans cette étape. La correction PLAY/STOP est une première réduction de risque, pas une certification de stabilité.


## Étape 20 — Moteur audio

- Séparation RNG interface / audio.
- DC blocker stéréo en sortie.
- Saturation douce en sortie au lieu d'un hard clip.
- À faire : synchronisation sans data race des patterns/paramètres de pas, retrait différé des buffers sample, tests de charge et compilation Windows.

## Étape 22 — durée de vie des buffers sampler
- Conservation des buffers publiés jusqu'à la destruction du processeur pour éviter leur désallocation dans le callback audio.
- Taux d'échantillonnage source atomiques.
- Plafond global de 512 Mio pour les buffers conservés ; imports refusés lorsque la réserve est pleine.
- À faire ensuite : reclamation différée sans blocage, streaming disque, tests de stress et compilation Windows.

## Étape 23 — Streaming (préparation)
- Architecture cible documentée : thread de lecture, ring buffer préalloué, consommation audio non bloquante.
- Le streaming n'est pas encore intégré ; le chemin RAM reste actif.
- Étape suivante : prototype SPSC sur une voix, mesures d'underruns et tests de simultanéité.

## Étape 24 — prototype de lecteur streaming

- Lecteur disque asynchrone et ring buffer stéréo préalloué ajoutés au projet.
- Interface de consommation sans verrou ni allocation dans `popSample()`.
- Intégration aux voix, seek, reverse, loop, slices et validation Windows restent à faire.


## Étape 25 — API streaming par blocs

API de copie stéréo par blocs sans allocation côté audio, compteurs d'underrun et métadonnées source atomiques. Connexion aux voix non réalisée à cette étape.

## Étape 26 — Pool multi-voix de streaming
- [x] Pool fixe de quatre lecteurs indépendants par sample.
- [x] API de lecture audio sans verrou ni allocation explicite.
- [ ] Raccordement au déclenchement des voix du sampler.
- [ ] Gestion des slices, du reverse, des boucles et du pitch dans le streaming.
- [ ] Tests de charge, underruns et compilation VST3 Windows.

- Étape 27 : audit du raccordement streaming ; intégration différée tant que le protocole de commandes et de repositionnement par génération n'est pas implémenté.


## Étape 28 — commandes de lecture
- [x] Commande de repositionnement/retrigger hors thread audio (commande publiée atomiquement).
- [x] Marquage par génération des frames du ring buffer et rejet des frames obsolètes côté consommateur.
- [ ] Raccordement à une voix pilote du sampler.
- [ ] Tests de charge et compilation Windows/VST3.


- [x] Étape 29 — cohérence du jeton de génération du lecteur.
- [x] Étape 30 — lecture par blocs via le pool de voix.
- [x] Étape 31 — métriques de disponibilité, source et underruns.
- [ ] Étape 32 — intégrer un chemin de streaming pilote au moteur de voix et valider les déclenchements.


## Étape 38 terminée (code préparé)
- Sécuriser le remplacement des lecteurs pendant que le moteur audio tourne.
- Garder le chemin RAM comme repli pendant la bascule.
- Prochaine priorité : compilation Windows, tests de charge et validation des transitions de sample.
