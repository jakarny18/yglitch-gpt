# Étape 38 — Bascule de sample sécurisée

## Changements
- Ajout d'un protocole d'accès streaming par piste (`streamingEnabled` + compteur de lecteurs actifs).
- Le thread UI désactive les nouveaux accès, attend la fin des appels en cours, puis remplace les lecteurs.
- Le thread audio vérifie à nouveau l'état après incrément du compteur, ce qui ferme la fenêtre de course entre le test initial et l'accès au pool.
- Un numéro d'époque invalide les anciennes voix streaming après changement de slot : elles restent sur leur copie RAM d'origine et ne lisent pas accidentellement le nouveau sample.
- Les voix conservent leur référence RAM : pendant un changement de slot, elles peuvent continuer en lecture RAM au lieu de toucher des lecteurs en cours de remplacement.
- Le chemin streaming ne libère donc plus la dernière référence RAM de la voix lors du déclenchement.

## Limites / validation
- Le remplacement des lecteurs est toujours une opération non temps-réel et peut attendre l'arrêt des threads de lecture.
- Le streaming reste limité à la lecture avant à pitch unitaire. Reverse et pitch utilisent le chemin RAM.
- La mémoire RAM reste utilisée comme copie de secours.
- Pas de compilation JUCE/VST3 Windows exécutée dans cet environnement. Tests runtime audio indispensables avant diffusion.
