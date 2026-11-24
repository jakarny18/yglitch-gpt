# Étape 29 — correction du jeton de génération

## Correction

`StreamingSampleReader::requestPlayback()` renvoie désormais exactement la génération publiée dans `requestedGeneration` et `consumerGeneration`. L'ancienne implémentation renvoyait `next + 1`, c'est-à-dire un identifiant qui ne correspondait à aucune frame du ring buffer. Le retour est maintenant cohérent avec le contrat de génération.

## Limite

Le changement corrige le contrat d'identification des commandes. Il ne raccorde pas encore le lecteur aux voix du sampler.
