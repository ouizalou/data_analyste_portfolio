use assurance_vie;


-- 🧱 Vue : client_total_investi
/*
 * Vue : client_total_investi
 * But métier : Fournir pour chaque client le total des montants investis sur tous ses contrats.
 * Usage : Permettre une vision rapide de l’investissement global par client,
 * utile pour le suivi commercial et l’analyse financière.
 */

create view  client_total_investi as
select c.client_id, c.nom,c.prenom,sum(vp.montant) as total_investi
from clients c
join contrats ct on ct.client_id=c.client_id
join versements_programmes vp on vp.contrat_id=ct.contrat_id
group by c.client_id,c.nom,c.prenom;

select * from client_total_investi;

-- 🧱 Vue : classement_client_par_nombre_contrat_investi
/*
 * Vue : classement_client_par_nombre_contrat_investi
 * But métier : Classer les clients selon le nombre de contrats qu’ils détiennent
 * et le total investi dans ces contrats.
 * Usage : Identifier les clients les plus actifs et les plus investis
 * pour des actions ciblées de fidélisation ou marketing.
 */

create view classement_client_par_nombre_contrat_investi as
select c.client_id, c.nom,c.prenom,count(ct.contrat_id) as nombre_contrat
,sum(vp.montant) as total_investi
from clients c
join contrats ct on ct.client_id=c.client_id
join versements_programmes vp on vp.contrat_id=ct.contrat_id
group by c.client_id,c.nom,c.prenom;

select *,rank() over (order by total_investi desc ) as rang from classement_client_par_nombre_contrat_investi;


-- 🧱 Vue : contrat_par_intermediaire
/*
 * Vue : contrat_par_intermediaire
 * But métier : Calculer pour chaque intermédiaire le montant total investi
 * et le nombre de contrats gérés.
 * Usage : Évaluer la performance commerciale des intermédiaires
 * et leur contribution à la gestion des contrats.
 */


create view contrat_par_intermediaire as
select i.intermediaire_id,i.nom,i.prenom,sum(vp.montant) as montant_investi
,count(distinct ct.contrat_id) as nombre_contrat
from intermediaires i
join  contrats ct on i.intermediaire_id=ct.intermediaire_id
join versements_programmes vp on vp.contrat_id=ct.contrat_id
group by i.intermediaire_id,i.nom,i.prenom;

select * from contrat_par_intermediaire;

-- 🧱 Vue : classement_intermediaire_par_investisement
/*
 * Vue : classement_intermediaire_par_investisement
 * But métier : Classer les intermédiaires en fonction du montant investi
 * sur leurs contrats signés depuis le 1er janvier 2024.
 * Usage : Suivi des performances commerciales récentes des intermédiaires,
 * pour motiver et orienter les actions commerciales.
 */


create view classement_intermediaire_par_investisement as
select i.intermediaire_id,i.nom,i.prenom,
count(distinct c.contrat_id) as nombre_contrat,
sum(vp.montant) as montant_investi,
rank () over (order by sum(vp.montant)desc) as rang_investisement
from intermediaires i
join contrats c on i.intermediaire_id=c.intermediaire_id
join versements_programmes vp on vp.contrat_id=c.contrat_id
where c.date_signature >='2024-01-01'
group by i.intermediaire_id,i.nom,i.prenom;

select * from  classement_intermediaire_par_investisement;

-- 🧱 Vue : client_risque
/*
 * Vue : client_risque
 * But métier : Évaluer le niveau de risque d’un client en combinant
 * le total investi, le nombre de sinistres déclarés, et le montant moyen des sinistres.
 * Usage : Aider à la gestion du risque et à la personnalisation des offres,
 * en identifiant les clients à risque élevé.
 */


create view client_risque as 
select ci.client_id,ci.nom,ci.prenom,ci.total_investi,
ifnull (sc.nombre_sinistre,0) as nombre_sinistre,
ifnull(sc.montant_moyen_sinistre,0) as montant_moyen_sinistre
from
    -- Sous-requête pour le montant total investi par client
	
(select c.client_id,c.nom,c.prenom, sum(vp.montant) as total_investi
from clients c
join contrats ct on ct.client_id=c.client_id
join versements_programmes vp on vp.contrat_id=ct.contrat_id
group by c.client_id,c.nom,c.prenom) as ci

left join(
    -- Sous-requête pour le nombre et montant moyen des sinistres par client
	
select c.client_id,count(s.sinistre_id) as nombre_sinistre,
avg(s.montant) as montant_moyen_sinistre
from contrats c
join sinistres s on s.contrat_id=c.contrat_id
group by c.client_id) as sc on ci.client_id=sc.client_id;

select * from client_risque;



