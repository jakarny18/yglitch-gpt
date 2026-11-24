# Étape 31 — diagnostics du pool de streaming

## Ajouts

Le pool expose maintenant, pour chaque voix :

- nombre de frames actuellement disponibles ;
- longueur de la source en frames ;
- fréquence d'échantillonnage de la source ;
- nombre d'underruns, ainsi que le total du pool.

Ces métriques permettent à l'interface et aux tests de vérifier le préchargement et les manques de données sans accéder directement aux lecteurs.

## Limites non résolues

- Le pool reste autonome et n'est pas connecté aux six pistes de `PluginProcessor`.
- Les samples du moteur continuent d'être lus depuis les buffers RAM existants.
- Les slices, le reverse, les boucles et le pitch ne sont pas encore gérés par le streaming.
- Le pool ouvre quatre lecteurs du même fichier, ce qui est une première architecture de prototype, pas encore une solution optimisée pour une bibliothèque complète.
- Aucune compilation JUCE ni validation dans un hôte VST3 Windows n'a été exécutée ici.
