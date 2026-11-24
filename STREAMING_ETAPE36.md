# Étape 36 — Budget mémoire et performance

Les buffers de streaming sont préalloués et de taille fixe. Le callback audio ne fait ni accès disque, ni allocation explicite, ni verrou pour lire les frames. Chaque piste dispose de quatre ring buffers stéréo de 65 536 frames. Le budget des rings est d’environ 12 Mio au total pour six pistes (hors métadonnées et objets JUCE). Les underruns sont comptabilisés et exposés par getStreamingUnderruns().

Le chargement initial d’un sample continue également de créer une copie RAM pour les fonctions non prises en charge par le streaming. Le streaming ne réduit donc pas encore à lui seul la RAM totale des samples importés.
