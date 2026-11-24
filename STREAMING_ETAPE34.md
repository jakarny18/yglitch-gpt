# Étape 34 — Six pistes

Le processeur possède un pool de streaming par piste : KICK, SNARE, HAT, CLAP, BASS et LEAD. Le chargement et le changement de slot ouvrent le fichier sélectionné sur le thread appelant, jamais dans renderVoice(). Le chemin RAM reste disponible comme solution de repli.
