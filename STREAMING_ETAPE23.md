# Étape 23 — Préparation du streaming audio depuis le disque

## État réel de cette étape

Cette étape prépare l'intégration du streaming, mais **n'active pas encore le streaming dans le moteur de lecture**. Les samples restent décodés en RAM et le moteur actuel continue d'utiliser des buffers audio immuables.

Il serait dangereux de remplacer directement les lectures de `AudioBuffer` par des lectures de fichiers dans `processBlock()` : le callback audio ne doit jamais attendre un accès disque, un verrou, une allocation ou un décodage.

## Architecture cible

1. **Thread de lecture dédié** : chaque sample streamé est lu en dehors du callback audio avec un `AudioFormatReader` détenu par le thread de lecture.
2. **Ring buffer préalloué** : le thread remplit des blocs PCM dans une mémoire circulaire fixe. Aucun redimensionnement ni allocation dans le callback audio.
3. **Consommation non bloquante** : `processBlock()` ne fait que lire les échantillons déjà disponibles. Si le tampon est vide, la voix produit un silence sur la portion manquante et incrémente un compteur d'underrun.
4. **Prélecture** : le thread maintient une avance configurable (cible initiale : 1 à 2 secondes) et réagit aux demandes de saut/seek sans bloquer le moteur.
5. **Cycle de vie** : arrêt et destruction du lecteur uniquement après arrêt/join du thread de lecture, jamais depuis le callback audio.
6. **Politique hybride** : petits samples courts en RAM, longs samples et banques volumineuses en streaming. Les seuils doivent être configurables.

## Pourquoi le streaming n'est pas encore branché

Le moteur actuel déclenche plusieurs voix par piste, permet reverse, loop, start/end, slicing et changement de slot. Pour intégrer le streaming correctement, chaque voix doit avoir un lecteur logique indépendant ou une stratégie de partage avec demandes de lecture coordonnées. Un simple lecteur partagé par slot casserait les lectures simultanées et les positions indépendantes des voix.

## Tests obligatoires avant activation

- lecture simultanée de plusieurs voix du même fichier à des positions différentes ;
- loop et reverse sans accès disque dans `processBlock()` ;
- changement de sample pendant une lecture ;
- seeks rapides et slices successives ;
- underruns simulés (disque lent / CPU chargé) ;
- arrêt du plugin pendant une lecture ;
- vérification que le callback audio ne prend aucun verrou et ne fait aucune allocation ;
- tests Windows x64 en Standalone et VST3 dans plusieurs hôtes.

## Fonctionnalités inchangées dans cette archive

- 6 pistes et séquenceur 1024 pas ;
- 300 slots par piste (1800 au total) ;
- moteur d'effets et contrôles des étapes précédentes ;
- plafond de 512 Mio pour les buffers conservés en RAM.

## Prochaine sous-étape

Implémenter le ring buffer SPSC préalloué et un thread de lecture par instance de flux, puis l'intégrer à une voix pilote avant de migrer toutes les pistes. Ne pas supprimer le chemin RAM tant que les tests de simultanéité et de latence ne sont pas validés.
