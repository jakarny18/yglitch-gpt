# Étape 37 — Vérification et plan de validation

Contrôles réalisés dans cet environnement : vérification des références de méthodes ajoutées, contrôle des délimiteurs C++ et inspection des chemins de repli. Aucun compilateur JUCE/VST3 Windows n’est disponible ici ; la compilation et les essais dans un hôte restent à effectuer.

## Tests manuels requis sous Windows
1. Charger un WAV mono puis stéréo sur chacune des six pistes.
2. Déclencher quatre voix qui se chevauchent sur une piste.
3. Vérifier retrigger rapide et lecture de slices.
4. Vérifier boucle avant, puis confirmer que reverse et pitch non nul basculent sur le chemin RAM.
5. Lire un fichier long et surveiller les underruns.
6. Changer de slot pendant la lecture et tester la fermeture du plugin.
7. Tester Standalone puis VST3 dans au moins deux hôtes.

## Limite importante
Le changement de slot réouvre actuellement le pool de la piste depuis le chemin UI/state. Avant de considérer le streaming comme production-ready, il faut ajouter une procédure de bascule de source avec échange différé (double-buffer/hazard/epoch) et tester les changements de slot pendant une lecture active. Le code n’est pas certifié sans ces essais.
