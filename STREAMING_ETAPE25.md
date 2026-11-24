# Étape 25 — API de lecture par blocs et métadonnées du flux

## Modifications

- Ajout de `popBlock()` : copie un bloc stéréo vers des buffers fournis par l'appelant, sans allocation, verrou ni accès disque.
- Les échantillons indisponibles sont remplis avec des zéros et un underrun est comptabilisé.
- Publication atomique de la longueur source et de sa fréquence d'échantillonnage.
- Ces métadonnées permettent au futur moteur de calculer les positions et le ratio de lecture sans interroger le lecteur disque.

## Limites importantes

Cette étape améliore l'interface temps réel du module, mais **ne connecte toujours pas le streaming aux voix du sampler**. Les voix du plugin continuent de lire les buffers entièrement décodés en RAM. Le module actuel reste un flux séquentiel mono-consommateur : pas encore de seek/retrigger indépendant, de boucle, de reverse, de lecture simultanée de plusieurs voix ni de conversion de fréquence intégrée.

## Vérifications

Vérification statique des signatures et des chemins d'appel effectuée. Aucune compilation JUCE ni exécution VST3/Standalone Windows n'a été réalisée dans cet environnement.

## Prochaine étape

Concevoir un pool de lecteurs/voix avec commandes de déclenchement asynchrones et lecture interpolée, puis connecter une piste pilote au sampler avant de généraliser aux six pistes.
