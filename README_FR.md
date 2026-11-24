# YouGlitch SMP 1024 — prototype natif JUCE, étape 21

**Prototype de développement uniquement.** Aucun binaire VST3 ou EXE Windows n'est inclus ni annoncé comme testé.

## Fonctionnalités présentes dans le prototype
- Moteur audio C++ exécuté dans `processBlock`, sans Web Audio.
- Six pistes de synthèse : KICK, SNARE, HAT, CLAP, BASS, LEAD.
- Horloge 16e, BPM 80–220, swing et variation temporelle CHAOS.
- Pattern 1024 pas par piste, 16 pages de 64 pas, répétitions 1/2/4.
- Glitch lane 1024 pas avec premiers traitements natifs KILL, DIST, RING et DELAY.
- Volume, panoramique, mute et solo par piste.
- Sauvegarde de l'état des paramètres et des patterns.
- Interface de test temporaire.

## Pas encore porté
L'interface HTML exacte, les banques sonores complètes, l'import et le décodage des samples, ADSR et filtres par piste, les 15 effets complets, le mapping MIDI original, les 50 presets, l'enregistrement et l'export WAV/stems restent à implémenter. Cette version ne doit pas être utilisée comme remplacement complet du HTML.

## Compiler sous Windows
Prérequis : Visual Studio 2022 (charge de travail C++), CMake 3.22+, connexion internet au premier lancement (JUCE 8.0.6 est récupéré par CMake).

Dans « x64 Native Tools Command Prompt for VS 2022 » :
```bat
cmake -S . -B build -A x64
cmake --build build --config Release
```
Les cibles VST3 et Standalone sont définies dans CMake. Vérifier la compilation, les sorties audio, la stabilité et le chargement dans un hôte avant toute distribution.

Le HTML fourni est conservé dans `Reference/YouGlitch_SMP_1024_original.html`.


## Étape 3 — sélection des sons par piste
- Ajout d'un paramètre de sélection de son par piste dans l'état du plugin.
- Sélecteur de son dans l'interface de test.
- Les variations de patch modifient la forme d'onde, la hauteur, la décroissance, le bruit et la modulation selon la piste.
- Il s'agit d'une banque paramétrique native de test (418 choix par piste), pas encore de la reproduction bit-à-bit des banques du HTML ni des samples importés.


## Étape 4 — chargement et lecture de samples

Cette étape ajoute un bouton **IMPORTER SAMPLE** pour la piste sélectionnée. Le moteur décode le fichier, conserve un buffer audio en mémoire et le lit à chaque déclenchement de cette piste. Les samples sont indépendants pour les six pistes. Le chemin du fichier est enregistré dans l'état du plugin afin de tenter de le recharger à la restauration du projet.

- Formats proposés dans le sélecteur : WAV, AIFF, FLAC, OGG, MP3 et M4A.
- La prise en charge réelle dépend des codecs activés dans la version JUCE utilisée ; WAV/AIFF sont les formats les plus sûrs. M4A/MP3 peuvent ne pas être décodés dans une compilation JUCE standard.
- Limite de sécurité actuelle : 10 minutes par sample et maximum 2 canaux.
- Le sample importé remplace le son synthétique de la piste ; sans sample, le synthétiseur de l'étape précédente reste actif.
- L'interface reste provisoire : le design HTML original n'a pas encore été reproduit.

**Limites importantes :** cette étape n'est pas encore un sampler complet (pas encore de découpage, de banques multiples, de zones, de pitch/loop/trim, ni d'import par glisser-déposer). Le chargement est fait depuis l'interface, et le rendu du sample est en lecture simple à vitesse nominale. Le code n'a pas été compilé ni testé dans un hôte VST3 sous Windows dans cet environnement.


## Étape 5 — édition du sample et slots multiples

La base de cette version a été étendue à **300 slots de samples par piste** (1 800 emplacements maximum pour les six pistes). Le bouton d'import ajoute le fichier au premier slot libre ; si les 300 sont occupés, il remplace le slot actuellement sélectionné. Le sélecteur SAMPLE permet de choisir le slot lu par la piste.

Commandes d'édition ajoutées :
- **DÉBUT** : position de départ, de 0 à 99 %.
- **FIN** : position de fin, de 1 à 100 %.
- **PITCH** : transposition de -24 à +24 demi-tons.
- **BOUCLE** : boucle la lecture entre les points de début et de fin.

Les fichiers et leur chemin sont enregistrés dans l'état du plugin et rechargés à la restauration du projet. Les réglages de début, fin, pitch et boucle sont des paramètres séparés pour chaque piste.

**Limites à connaître :** pas encore de forme d'onde visuelle, de découpage automatique en slices, de crossfade de boucle, de réglage de volume/enveloppe dédié au sample, ni de navigateur de banque. Le sélecteur propose plusieurs formats mais leur lecture dépend des codecs de la compilation JUCE. La boucle utilise une reprise directe sans crossfade. Le projet reste du code source non compilé/non testé dans un hôte Windows ; aucun VST3/EXE n'est inclus.


## Étape 6 — slices + compilation automatique sur GitHub

### Découpage en slices
- Jusqu'à 32 divisions régulières du sample sélectionné par piste.
- Commande SLICES pour choisir le nombre de divisions.
- 8 boutons de déclenchement rapide SL 1 à SL 8 dans l'éditeur provisoire.
- Chaque déclenchement lit la tranche correspondante avec les réglages de début/fin, pitch et boucle.

Le découpage est régulier (tranches de même longueur) : il n'y a pas encore de détection automatique des transitoires, de déplacement manuel des marqueurs ou de forme d'onde dessinée.

### Compiler avec GitHub Actions (Windows x64)
1. Créer un dépôt GitHub vide.
2. Décompresser tout le contenu de cette archive et envoyer **tous les fichiers et dossiers** à la racine du dépôt (le dossier `.github` doit être présent).
3. Dans GitHub, ouvrir l'onglet **Actions**.
4. Lancer le workflow **Build Windows VST3 and Standalone**, ou faire un push sur `main` / `master`.
5. Attendre que les étapes Configure et Build soient vertes.
6. Ouvrir l'exécution terminée et télécharger l'artefact **YouGlitch-SMP-1024-Windows-x64**.

Le workflow télécharge JUCE 8.0.6 automatiquement au moment de la configuration CMake, puis demande à MSVC de compiler les formats VST3 et Standalone en 64 bits.

### Limites et vérification
Cette archive contient la configuration GitHub Actions, mais je ne peux pas lancer GitHub Actions depuis ton compte ni confirmer un build Windows réel ici. Le projet est préparé pour compilation ; le premier résultat de GitHub Actions reste le test décisif. Si GitHub affiche une erreur, envoie-moi le log rouge complet et je corrigerai le projet. Les fonctions du projet original qui ne sont pas encore portées restent à développer ; cette étape ne constitue pas encore une conversion fonctionnelle complète de l'application HTML.


## Étape 7 — éditeur de forme d'onde

La zone du sampler affiche maintenant une forme d'onde calculée à partir du sample du slot sélectionné :
- aperçu mono de l'amplitude maximale des canaux ;
- marqueurs de début et de fin ;
- déplacement des marqueurs à la souris ;
- lignes de repère pour les slices régulières ;
- synchronisation avec les contrôles DÉBUT / FIN et les paramètres du projet.

Le découpage reste régulier, sans détection automatique de transitoires. Les 8 boutons SL 1 à SL 8 déclenchent les huit premières tranches ; le nombre total de tranches peut être réglé jusqu'à 32.

### Compilation GitHub
Le workflow Windows x64 du dossier `.github/workflows/` est conservé. Il compile les cibles VST3 et Standalone et publie les artefacts dans l'onglet Actions. Le premier build GitHub doit encore être exécuté et validé.

### Important
Cette livraison est une étape de développement ciblée : elle n'implémente pas encore toutes les fonctions proposées dans la feuille de route. Aucun binaire VST3 ou EXE n'est fourni ici. Le code n'a pas été compilé dans cet environnement, faute de dépendance JUCE récupérable et d'outilchain Windows.


## Étape 8 — séquenceur avancé par pas

Ajouts dans le moteur et l'éditeur :
- **Probability** par pas : de 0 à 100 %, avec tirage aléatoire à chaque passage du séquenceur.
- **Ratchet** par pas : de 1 à 4 déclenchements répartis dans la durée du pas.
- **Micro-shift positif** : décalage tardif réglable de 0 à 45 % de la durée du pas.
- Sélection visuelle du pas actif dans la grille ; les réglages Probability, Ratchet et Micro-shift s'appliquent au pas sélectionné.
- Sauvegarde/restauration de ces valeurs dans l'état du plugin, avec compatibilité de lecture des anciens états qui ne contiennent que le pattern et la lane glitch.

Le nombre de répétitions indiqué par le niveau de pas dans la grille reste pris en compte comme nombre minimal de ratchets : cette compatibilité évite de perdre le comportement rythmique de l'ancien prototype.

**Limite actuelle du micro-timing :** ce contrôle décale les événements vers l'arrière (late) uniquement. Le décalage négatif/early, les conditions de déclenchement, le chaînage de patterns et la synchronisation au transport de l'hôte restent à développer.


## Étape 9 — lecture inversée et enveloppe ADSR du sampler

Ajouts :
- **INVERSÉ** : lecture du sample ou de la slice sélectionnée de la fin vers le début.
- **A / D / S / R** : enveloppe d'amplitude par piste, avec attaque, décroissance, niveau de sustain et fondu de relâchement en fin de lecture.
- Les réglages ADSR, Reverse et Loop sont des paramètres du projet et suivent la piste sélectionnée.
- La lecture inversée respecte les points DÉBUT / FIN et le découpage en slices.
- La boucle continue à boucler ; le Release est appliqué à la fin d'une lecture One-Shot, pas lors d'une boucle infinie.

**Limites :** le Release n'est pas encore piloté par un événement MIDI Note-Off ; il sert de fondu de fin pour les lectures non bouclées. Le mode Gate, le crossfade de boucle, le time-stretch indépendant du pitch et la détection automatique des transitoires restent à faire. Cette étape est du code source non compilé et non testé dans un hôte audio.


## Étape 10 — mode MIDI Gate

Ajouts :
- **MIDI GATE** par piste : lorsqu'il est activé, une note MIDI maintient la voix tant que la touche reste enfoncée.
- Les notes MIDI **36 à 41** déclenchent respectivement KICK, SNARE, HAT, CLAP, BASS et LEAD.
- Le relâchement MIDI déclenche un fondu selon le paramètre **Release** de la piste.
- Les événements MIDI sont traités à leur position d'échantillon dans le bloc audio ; ils ne sont plus ignorés.
- Une note-off arrête également la boucle d'un sample tenu en mode Gate.

**Utilisation :** active MIDI GATE sur la piste voulue, puis envoie la note correspondante depuis un clavier ou une piste MIDI. Désactive MIDI GATE pour conserver le comportement One-Shot du séquenceur et des déclenchements habituels.

**Limites :** le mapping MIDI est fixe (36–41) et n'est pas encore personnalisable. Le Gate est un maintien de voix par note MIDI ; il ne remplace pas encore un mode Gate synchronisé à la longueur des pas du séquenceur. Code source non compilé et non testé dans un hôte audio.


## Étape 11 — MIDI Learn pour les contrôleurs CC

Ajouts :
- Sélection d'une cible : BPM, Densité, Chaos, Swing, Master FX ou volume d'une des six pistes.
- Bouton **APPRENDRE CC** : bouger un potentiomètre ou fader MIDI pour lui associer le contrôleur CC.
- Les valeurs MIDI 0–127 pilotent la plage de la cible sélectionnée.
- Les associations CC sont sauvegardées dans l'état du plugin.
- Un même CC peut piloter plusieurs cibles si on l'assigne à chacune.

**Procédure :** choisir une cible dans la liste, cliquer sur APPRENDRE CC, puis tourner un bouton physique du contrôleur. Le statut affiche le numéro CC associé. Ensuite, bouger ce bouton pilote le paramètre.

**Limites :** les affectations sont globales au plugin et non par preset indépendant. Les mises à jour des paramètres sont envoyées aux valeurs atomiques du moteur ; l'automation/notification de l'hôte pour les mouvements CC externes doit être validée dans un vrai hôte. Code source non compilé et non testé.


## Étape 12 — plages MIDI personnalisables

Ajouts :
- **MIN % / MAX %** pour limiter la plage parcourue par un contrôleur CC.
- **INVERSER CC** pour inverser le sens du potentiomètre ou du fader.
- Les plages sont configurables séparément pour chacune des 11 cibles MIDI Learn.
- Les réglages de plage, d'inversion et les numéros CC sont sauvegardés dans l'état du plugin.
- Les limites sont exprimées en pourcentage de la plage native de la cible : BPM (80–220), macros (0–100 %), Master FX (seuil à 50 %) et volumes de piste (0–200 %).

**Limites :** un CC peut toujours être affecté à plusieurs cibles ; le filtrage, la courbe logarithmique et le MIDI Learn des paramètres de sampler/effets individuels ne sont pas encore inclus. Code source non compilé et non testé.


## Étape 13 — courbes de réponse MIDI CC

Ajouts :
- Sélecteur de courbe par cible MIDI Learn : **Linéaire**, **Exponentielle** et **Logarithmique**.
- La courbe est appliquée après l'inversion éventuelle et avant la plage MIN/MAX.
- Courbe linéaire : réponse directe du contrôleur.
- Courbe exponentielle : progression plus fine dans le bas de la plage (valeur normalisée au carré).
- Courbe logarithmique : progression plus rapide dans le bas de la plage (racine carrée de la valeur normalisée).
- Les courbes sont sauvegardées indépendamment pour chacune des 11 cibles.

**Limites :** les deux courbes non linéaires sont des fonctions simples de forme x² et √x ; elles ne disposent pas encore d'un réglage de tension. Pas de lissage temporel des CC. Code source non compilé et non testé dans un hôte audio.


## Étape 14 — premiers effets GLITCH en temps réel

Ajouts au moteur audio :
- **FREEZE (code 1)** : répète une courte fenêtre audio capturée dans un buffer circulaire.
- **STUTTER (code 2)** : répète une fenêtre plus courte pour un effet de bégaiement rythmique.
- **BITCRUSH (code 11)** : réduction de résolution à environ 4 bits utiles et maintien d'échantillons sur 4 frames.
- **TAPE STOP (code 12)** : lit une fenêtre récente avec une vitesse qui descend progressivement jusqu'à l'arrêt.
- Les effets sont activés par la lane GLITCH et par le commutateur Master FX. Une légende des codes est affichée dans l'interface.

Les traitements existants KILL (4), RING (5), DIST (6) et DELAY (9/10) restent dans la chaîne.

**Limites :** les fenêtres FREEZE/STUTTER sont fixes (180 ms / 90 ms) et le TAPE STOP dure environ 350 ms ; ces durées ne sont pas encore synchronisées au BPM. Le buffer est un effet de performance simple, pas un véritable moteur granulaire. Le fondu/crossfade des boucles d'effet et les contrôles de mixage par effet restent à faire. Code source non compilé et non testé dans un hôte audio.


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


## Étape 17 — catégories et favoris du navigateur

- Filtre par catégorie (percussions, FX, tonal, voix) à partir de mots-clés présents dans le nom du fichier.
- Bouton pour marquer/démarquer le sample sélectionné comme favori.
- Filtre « favoris seuls » combinable avec la recherche textuelle.
- Favoris conservés pendant la session de l'éditeur uniquement : leur persistance dans les projets/presets reste à développer.
- Les catégories sont heuristiques et non des métadonnées modifiables.
- Code source non compilé et non testé dans un hôte VST3.

## Étape 18 — première passe de stabilisation

- La commande PLAY/STOP ne modifie plus directement les voix et les files d'attente audio depuis le thread de l'interface.
- Elle transmet une demande atomique ; la remise à zéro du transport, des voix et des déclenchements différés est effectuée dans `processBlock`, côté thread audio.
- Cette correction réduit une source de concurrence entre l'interface et le moteur audio.

### Validation de cette étape

- Vérification statique des fichiers source effectuée.
- Tentative de configuration CMake effectuée dans l'environnement de développement.
- La configuration n'a pas pu aller au bout : JUCE 8.0.6 doit être récupéré depuis GitHub, mais l'environnement ne résout pas `github.com` (échec DNS/réseau).
- Par conséquent, aucun binaire VST3/Standalone n'a été produit ici et aucun test audio réel n'est revendiqué.

### Points restant à valider avant une version stable

1. Compiler avec Visual Studio 2022 sur Windows x64.
2. Tester PLAY/STOP et les changements de transport pendant la lecture.
3. Auditer les accès concurrents au pattern, aux paramètres par pas et aux métadonnées des samples.
4. Tester le remplacement d'un sample pendant la lecture et la restauration d'un projet.
5. Tester MIDI, boucles, effets GLITCH, plusieurs fréquences d'échantillonnage et tailles de buffer.
6. Mesurer CPU, mémoire et stabilité sur une session prolongée.


## Étape 20 — Améliorations du moteur audio

- Séparation des générateurs aléatoires : le moteur audio utilise `audioRandom`, la randomisation de pattern utilise `uiRandom`. Cela évite le partage concurrent du même générateur entre l'interface et le thread audio.
- Ajout d'un filtre anti-composante continue (DC blocker) sur les sorties stéréo.
- Remplacement de l'écrêtage dur final par une saturation douce `tanh`, pour limiter les artefacts lorsque le mix dépasse 0 dBFS.
- Réinitialisation de l'état du DC blocker dans `prepareToPlay`.

**Validation :** vérification structurelle du code uniquement. Aucune compilation JUCE/Windows ni mesure audio n'a été effectuée. Les accès concurrents aux patterns et aux paramètres de pas identifiés à l'étape 19 restent à corriger dans une étape dédiée.

## Étape 21 — sécurité du séquenceur
Les cellules du pattern, les paramètres par pas (probabilité, ratchet, micro-shift) et la lane GLITCH utilisent maintenant des atomiques pour éviter les data races entre interface et callback audio. La sauvegarde convertit ces données en tableaux temporaires avant sérialisation. Voir `SECURITE_AUDIO_ETAPE21.md` pour les limites restantes.

## Étape 22 — sécurité de la mémoire des samples

Le moteur conserve maintenant une référence propriétaire à chaque buffer de sample publié, jusqu'à la destruction du processeur. Ainsi, lorsqu'une voix audio termine ou qu'un slot est remplacé, la libération du dernier buffer ne peut pas se produire dans le callback audio. Les taux d'échantillonnage source sont également stockés dans des atomiques, afin que leur lecture par le moteur ne dépende pas d'un verrou d'interface.

Une limite globale de **512 Mio de buffers décodés conservés** est appliquée. Elle est volontairement cumulative : remplacer un slot ne libère pas immédiatement l'ancien buffer, car une voix audio peut encore l'utiliser. Quand cette réserve est épuisée, le nouvel import est refusé plutôt que de risquer une libération mémoire depuis le thread audio. Un redémarrage du plugin libère la réserve.

**Compromis et limites :** cette étape privilégie la sécurité temps réel à la récupération immédiate de mémoire. Elle ne met pas encore en place un véritable streaming depuis le disque ni un système de reclamation différée avec epochs/hazard pointers. Les buffers restent décodés en RAM. Le projet n'a pas été compilé ni testé dans un hôte VST3 Windows dans cet environnement.

## Étape 23 — Préparation du streaming

Le document `STREAMING_ETAPE23.md` décrit l'architecture sûre pour le streaming depuis le disque et les tests nécessaires. **Le streaming n'est pas encore activé** : les samples restent chargés en RAM à ce stade. Cette distinction évite de présenter une simple préparation comme une fonction déjà opérationnelle.

## Étape 24 — prototype de streaming disque

Un module `StreamingSampleReader` a été ajouté. Il décode les fichiers sur un thread dédié et expose un ring buffer stéréo préalloué au consommateur audio. **Ce prototype n'est pas encore connecté aux voix du sampler** : la lecture du plugin reste actuellement basée sur les buffers RAM. Voir `STREAMING_ETAPE24.md` pour les limites et les étapes d'intégration.


### Étape 25 — lecture par blocs

Le lecteur de streaming expose désormais `popBlock()` et les métadonnées atomiques du fichier (durée en frames et fréquence source). Cela prépare l'intégration temps réel, mais les voix continuent d'utiliser les samples décodés en RAM. Voir `STREAMING_ETAPE25.md`.

## Étape 26 — Pool de streaming multi-voix

Ajout du module `StreamingVoicePool` : quatre lecteurs disque indépendants pour préparer quatre déclenchements simultanés d'un même sample. Le module est compilé dans la cible CMake, mais son raccordement aux voix du sampler reste à faire. Voir `STREAMING_ETAPE26.md`.

## Étape 27 — audit d'intégration du streaming

Voir `STREAMING_ETAPE27.md`. Le lecteur disque de l'étape 26 reste autonome et n'est pas encore connecté aux voix : son API séquentielle actuelle ne permet pas de garantir correctement les redéclenchements, slices, reverse et boucles. Le moteur continue donc d'utiliser les samples en RAM. Aucun test de compilation VST3 Windows n'a été effectué.


## Étape 28 — commandes de lecture du streaming

Le lecteur possède maintenant une commande `requestPlayback(startFrame)` et un marquage des frames par génération pour écarter les données d’un ancien retrigger. Cette brique reste autonome et n’est pas encore raccordée aux voix du sampler. Voir `STREAMING_ETAPE28.md`.


## Étapes 29 à 31

Voir `STREAMING_ETAPE29.md`, `STREAMING_ETAPE30.md` et `STREAMING_ETAPE31.md` pour les corrections de génération, la lecture par blocs et les diagnostics du pool. Le streaming reste un module autonome, non connecté au sampler principal.


## Étape 38 — Sécurisation du changement de sample

Le remplacement des lecteurs de streaming est désormais protégé par un protocole d'accès actif par piste. Les voix gardent une copie RAM de secours et basculent vers elle pendant le changement de slot. Voir `STREAMING_ETAPE38.md`. Compilation et test dans un hôte VST3 Windows restent à effectuer.
