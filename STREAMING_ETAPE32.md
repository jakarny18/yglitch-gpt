# Étape 32 — Première connexion au sampler

Le sampler possède désormais un chemin de lecture en streaming par piste. Lorsqu’un sample est chargé ou sélectionné, le pool de la piste ouvre le fichier hors du callback audio. Une voix compatible peut ensuite demander un départ à la position de son slice et consommer les frames depuis le ring buffer.

Le chemin streaming est volontairement limité à la lecture avant à vitesse correspondant au taux du projet. Les combinaisons pitch non nul, reverse et les fréquences nécessitant une conversion restent sur le chemin RAM existant. Cela évite de prétendre que le streaming sait déjà faire du resampling ou du reverse.
