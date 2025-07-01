use assurance_vie;


-- 🧱 vue des clients avec le total investi

create view  client_total_investi as
select c.client_id, c.nom,c.prenom,sum(vp.montant) as total_investi
from clients c
join contrats ct on ct.client_id=c.client_id
join versements_programmes vp on vp.contrat_id=ct.contrat_id
group by c.client_id,c.nom,c.prenom;

select * from client_total_investi;


-- 🧱 vue de classement des clients par nombre des contrats et le total investi

create view classement_client_par_nombre_contrat_investi as
select c.client_id, c.nom,c.prenom,count(ct.contrat_id) as nombre_contrat
,sum(vp.montant) as total_investi
from clients c
join contrats ct on ct.client_id=c.client_id
join versements_programmes vp on vp.contrat_id=ct.contrat_id
group by c.client_id,c.nom,c.prenom;

select *,rank() over (order by total_investi desc ) as rang from classement_client_par_nombre_contrat_investi;


-- 🧱 vue contrat_par_intermediaire

create view contrat_par_intermediaire as
select i.intermediaire_id,i.nom,i.prenom,sum(vp.montant) as montant_investi
,count(distinct ct.contrat_id) as nombre_contrat
from intermediaires i
join  contrats ct on i.intermediaire_id=ct.intermediaire_id
join versements_programmes vp on vp.contrat_id=ct.contrat_id
group by i.intermediaire_id,i.nom,i.prenom;

select * from contrat_par_intermediaire;

-- 🧱 vue classement intermediaire par investisement

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

-- 🧱 vue client risque (évaluer le niveau de risque d’un client)

create view client_risque as 
select ci.client_id,ci.nom,ci.prenom,ci.total_investi,
ifnull (sc.nombre_sinistre,0) as nombre_sinistre,
ifnull(sc.montant_moyen_sinistre,0) as montant_moyen_sinistre
from
	-- le montant total investi
(select c.client_id,c.nom,c.prenom, sum(vp.montant) as total_investi
from clients c
join contrats ct on ct.client_id=c.client_id
join versements_programmes vp on vp.contrat_id=ct.contrat_id
group by c.client_id,c.nom,c.prenom) as ci

left join( -- le nombre de sinistres déclarés et le montant moyen des sinistres

select c.client_id,count(s.sinistre_id) as nombre_sinistre,
avg(s.montant) as montant_moyen_sinistre
from contrats c
join sinistres s on s.contrat_id=c.contrat_id
group by c.client_id) as sc on ci.client_id=sc.client_id;

select * from client_risque;



