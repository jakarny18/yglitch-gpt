# Étape 21 — accès concurrents du séquenceur

## Changements
- Les 6 × 1024 valeurs du pattern sont désormais des `std::atomic<uint8_t>`.
- Probabilité, ratchet et micro-shift de chaque pas sont atomiques.
- La lane GLITCH (1024 pas) est atomique.
- Les lectures du callback audio utilisent des `load(memory_order_relaxed)` ; les écritures UI utilisent des `store(memory_order_relaxed)`. Ces champs sont des valeurs indépendantes : aucun ordre de synchronisation entre eux n'est requis pour éviter les data races.
- La sauvegarde reconstruit des tableaux POD temporaires avant sérialisation. Le format binaire existant (pattern + glitch + réglages par pas) est conservé, y compris la lecture de l'ancien format sans réglages par pas.

## Portée et limites
Cette étape supprime les accès concurrents non atomiques sur les tableaux de séquenceur identifiés à l'étape 19. Elle ne rend pas encore l'ensemble du moteur exempt de risques temps réel :
- les `shared_ptr` de samples peuvent encore libérer leur dernier buffer sur le thread audio ;
- le chargement/restauration des samples et leur cycle de vie doivent encore être séparés du callback audio ;
- les données d'un pattern sauvegardé pendant son édition forment un instantané sans garantie transactionnelle (chaque cellule est sûre, mais plusieurs cellules peuvent provenir de moments différents) ;
- les opérations de restauration d'état doivent être coordonnées avec l'hôte/transport ;
- le caractère lock-free des atomiques flottants dépend de la plateforme et doit être vérifié sur les cibles Windows.

## Vérification
Contrôles statiques des usages et de la sérialisation effectués. Aucun build JUCE/VST3 ni test audio Windows n'a été exécuté dans cet environnement. Le projet reste un prototype source.
