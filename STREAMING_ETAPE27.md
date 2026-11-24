# Étape 27 — audit d'intégration du streaming

## Résultat

Cette étape examine le raccordement du pool de lecteurs au moteur de voix. Le pool de l'étape 26 reste un prototype autonome : il n'est pas activé dans `processBlock()` et les voix continuent d'utiliser les buffers RAM.

## Pourquoi le raccordement direct n'est pas activé

Le `StreamingVoicePool` ouvre quatre lecteurs indépendants sur le même fichier. Chaque lecteur possède un curseur séquentiel, alimenté par son propre thread. L'API actuelle expose `popSample()` mais aucune commande temps réel de repositionnement/relecture synchronisée.

Or le moteur existant doit pouvoir, à chaque déclenchement :
- repartir au début ou à une position de slice précise ;
- réutiliser une voix après sa fin ;
- appliquer start/end, pitch, reverse et loop ;
- gérer un retrigger avant la fin de la lecture précédente.

Brancher simplement `popSample()` dans `renderVoice()` ferait continuer le curseur au lieu de redémarrer le sample. Après quelques déclenchements, les lecteurs atteindraient EOF et les voix seraient silencieuses. Ce serait une régression fonctionnelle.

## Contrat requis avant intégration

La prochaine implémentation doit introduire un protocole de commandes non bloquant entre audio et worker :
1. Le thread audio publie une commande de lecture (sample, frame de départ, identifiant de génération, voix).
2. Le worker prépare/remplit un flux dédié sans accès disque depuis `processBlock()`.
3. Le flux publie des blocs avec leur position source et leur génération.
4. Le thread audio consomme uniquement les blocs correspondant à la génération attendue ; en cas de manque, il produit du silence et incrémente un compteur underrun.
5. Le remplacement/fermeture d'un flux se fait hors du thread audio avec une stratégie de durée de vie vérifiée.

## Matrice de compatibilité à valider

| Fonction | État étape 27 |
|---|---|
| Lecture séquentielle du prototype | Présente dans le lecteur autonome |
| Déclenchement/retrigger depuis le début | Non intégré |
| Start/end et slices | Non intégrés au streaming |
| Pitch/interpolation | Non intégrés au streaming |
| Reverse | Non intégré au streaming |
| Loop | Non intégré au streaming |
| Six pistes simultanées | Non intégré au streaming |
| Tests hôte VST3 Windows | Non exécutés |

## Conclusion

Aucun faux raccordement n'a été ajouté. Le moteur existant reste fonctionnel sur son chemin RAM, et le prototype de streaming demeure disponible pour la prochaine étape de conception du protocole de commandes/segments. Le projet n'a pas été compilé ni testé dans un hôte VST3 Windows.
