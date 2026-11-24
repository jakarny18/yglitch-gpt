# Étape 22 — sécurité mémoire sampler

## Changement
Les buffers immuables publiés dans `sampleBuffers` sont aussi conservés dans `retainedSampleBuffers`, sous `sampleInfoLock` côté chargement. Le callback audio n'accède jamais à ce vecteur ni à ce verrou. Les références détenues par les voix peuvent donc être relâchées sans que cela détruise le buffer sur le thread audio.

`sampleSourceRates` devient un tableau d'atomiques, car `trigger()` le lit depuis le thread audio alors que le chargement de samples le met à jour depuis l'interface/restauration d'état.

## Limite mémoire
Plafond cumulatif : 512 Mio de données PCM décodées conservées. Les buffers remplacés restent comptabilisés et conservés jusqu'à la destruction du processeur. Ce choix évite la désallocation temps réel, mais une réclamation différée plus sophistiquée sera nécessaire pour un usage intensif et de longues sessions.

## Vérifications effectuées
- Vérification des occurrences de `sampleSourceRates` après conversion en atomiques.
- Vérification des chemins de publication : ajout au pool de rétention avant publication atomique.
- Pas de compilation JUCE/MSVC ni de test audio réel effectués ici.
