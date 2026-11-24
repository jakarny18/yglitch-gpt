# Étape 28 — commandes de lecture et générations de flux

## Objectif

Ajouter au lecteur de streaming une commande de repositionnement/retrigger qui ne réalise aucune opération disque sur le thread audio.

## Changements

- `StreamingSampleReader::requestPlayback(startFrame)` publie une nouvelle position de lecture et une nouvelle génération.
- Le thread de lecture observe la commande, effectue le repositionnement avec `AudioFormatReader::read()` à partir de la position demandée et remplit le ring buffer.
- Chaque frame du ring buffer porte la génération à laquelle elle appartient.
- Le consommateur audio ignore les frames des générations précédentes : un bloc déjà en cours de décodage au moment d'un retrigger ne peut donc pas être confondu avec le nouveau flux.
- `StreamingVoicePool::requestPlayback(voice, startFrame)` expose la commande par lecteur.
- Les fonctions de consommation restent sans accès disque, verrou ou allocation explicite.

## Limites connues

- Ce module reste un prototype autonome : il n'est pas encore relié aux voix du sampler dans `PluginProcessor`.
- Le pool conserve quatre lecteurs indépendants, mais le routage des déclenchements des six pistes n'est pas réalisé.
- Une seule source de commandes par lecteur est attendue (contrat SPSC / commande audio unique). Il ne faut pas appeler `open()` ou `close()` depuis le thread audio.
- La précision du retrigger dépend du temps de réaction du thread disque et du préremplissage du ring buffer. Une commande ne garantit pas une lecture sans underrun immédiat.
- Les slices, le reverse, le pitch et les boucles ne sont pas encore intégrés au moteur de streaming.
- Le projet n'a pas été compilé ni testé dans un hôte VST3 Windows dans cette étape.

## Test à effectuer ensuite

1. Ouvrir un fichier long depuis le thread message.
2. Attendre `isReady()` et un préremplissage suffisant.
3. Déclencher à plusieurs positions avec `requestPlayback()`.
4. Vérifier que les anciennes générations sont ignorées et que le compteur d'underruns reste maîtrisé.
5. Répéter les tests pendant une lecture continue avant d'intégrer une piste pilote.
