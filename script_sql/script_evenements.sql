USE assurance_vie;

-- Activation globale du planificateur d’événements SQL 

SET GLOBAL event_scheduler = ON;

/*
 * Événement planifié : detecter_contrat_inactifs
 * But métier : Détecter quotidiennement les contrats qui n'ont eu
 * aucune opération (versement, retrait, etc.) depuis plus de 12 mois.
 * Usage : Générer automatiquement une alerte dans la table `alertes_contrat`
 * pour suivi, relance commerciale ou audit interne.
 */

DELIMITER §§

CREATE EVENT IF NOT EXISTS detecter_contrat_inactifs
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_DATE + INTERVAL 1 DAY
DO 
BEGIN
    INSERT INTO alertes_contrat (contrat_id, type_alerte, message, date_alerte, statut)
    SELECT 
        c.contrat_id,
        'inactivite_12_mois',
        'Contrat inactif depuis plus de 12 mois. Aucun mouvement enregistré.',
        CURDATE(),
        'nouvelle'
    FROM contrats c
    WHERE NOT EXISTS (
        SELECT 1 
        FROM operations o 
        WHERE o.contrat_id = c.contrat_id
          AND o.date_operation >= CURDATE() - INTERVAL 12 MONTH
    );
END
§§



/*
 * Événement : detecter_clients_seniors
 * But métier : Générer une alerte mensuelle pour tous les clients ayant +75 ans
 *              avec au moins un contrat actif (hors résilié).
 * Usage : Permettre à la cellule de gestion d’anticiper les risques (succession, décès).
 * Fréquence : Mensuelle (1er du mois).
 */
DELIMITER ;

create event detecter_clients_seniors
on schedule every 1 MONTH
STARTS NOW() + INTERVAL 1 MINUTE
DO
begin
	insert into alertes_clients( client_id, nom, prenom, age, contrat_id, date_alerte, message, statut
    )
    select 
    cl.client_id,
        cl.nom,
        cl.prenom,
        TIMESTAMPDIFF(YEAR, cl.date_naissance, CURDATE()) AS age,
        c.contrat_id,
        CURDATE(),
        CONCAT('Client senior (', TIMESTAMPDIFF(YEAR, cl.date_naissance, CURDATE()), ' ans) avec contrat actif.'),
        'nouvelle'
    FROM clients cl
    JOIN contrats c ON c.client_id = cl.client_id
    WHERE 
        TIMESTAMPDIFF(YEAR, cl.date_naissance, CURDATE()) >= 75
        AND c.statut NOT IN ('resilie', 'cloture');  -- uniquement contrats actifs
END
§§

DELIMITER ;

/*
 * But métier : Identifier automatiquement les contrats dont la somme des
 *  			pourcentages attribués aux bénéficiaires dépasse 100%.
 * Usage : Déclencher une alerte pour correction administrative ou validation.
 * Fréquence : Quotidienne (vérification chaque jour).
 */

DELIMITER §§

CREATE EVENT IF NOT EXISTS detecter_erreurs_beneficiaires
ON SCHEDULE EVERY 1 DAY
STARTS NOW() + INTERVAL 1 MINUTE
DO
BEGIN
  INSERT INTO alertes_contrat (contrat_id, type_alerte, message, date_alerte, statut)
  
  SELECT contrat_id, 'beneficiaire_invalide',
         'La répartition des bénéficiaires dépasse 100%.',
         CURDATE(), 'nouvelle'
  FROM (
    SELECT contrat_id, SUM(pourcentage) as total
    FROM beneficiaires
    GROUP BY contrat_id
    HAVING SUM(pourcentage) > 100
  ) AS erreurs;
END;

DELIMITER ;

show events from assurance_vie;