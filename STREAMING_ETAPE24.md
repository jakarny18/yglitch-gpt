# Étape 24 — lecteur disque et ring buffer (prototype C++)

## Livré

- `StreamingSampleReader` ouvre un fichier audio sur un thread non-audio.
- Le thread de fond décode par blocs de 1024 frames.
- Les données sont publiées dans un ring buffer stéréo préalloué de 65 536 frames par canal.
- `popSample()` est l'interface consommateur prévue pour le thread audio : lecture atomique des index, aucune ouverture de fichier, aucun verrou et aucune allocation.
- Un compteur d'underruns permet de mesurer les manques de données.
- Le module est ajouté à la cible CMake.

## Limites importantes

Ce module est un prototype de lecteur séquentiel, pas encore le moteur de streaming complet du sampler. Il n'est pas encore relié aux voix du séquenceur : la lecture actuelle du plugin continue d'utiliser les buffers RAM existants. Il ne gère pas encore les seeks, les boucles, le reverse, les slices, ni plusieurs lecteurs concurrents par piste. La fréquence source est conservée pour préparer le rééchantillonnage, mais celui-ci n'est pas encore appliqué dans ce module.

Le ring buffer est conçu pour un seul producteur (thread disque) et un seul consommateur (thread audio). Ne pas appeler `open()` ou `close()` depuis `processBlock()`.

## Suite nécessaire avant activation

1. Intégrer un lecteur par voix ou un pool borné de lecteurs, sans partager un curseur entre voix indépendantes.
2. Ajouter les commandes de seek/retrigger avec acquittement du thread disque.
3. Ajouter interpolation/rééchantillonnage, boucles, reverse et slices.
4. Tester underruns, changement de sample, fermeture du plugin et accès concurrent sous Windows.
5. Mesurer la charge CPU et la latence avant d'activer le streaming par défaut.

## Validation

Contrôle de cohérence des fichiers et de la configuration CMake effectué. Aucune compilation JUCE ni validation dans un hôte VST3 Windows n'a été effectuée dans cet environnement. Le module ne doit donc pas être considéré comme validé en production.
