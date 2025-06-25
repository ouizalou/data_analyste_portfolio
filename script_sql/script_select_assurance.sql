use assurance_vie; 
  
-- 🔍 Rechercher tous les clients dont le revenu annuel dépasse 112 500 €

select  c.client_id,c.nom,c.prenom,c.date_naissance,c.ville,c.code_postal,c.revenu_annuel 
from clients c
where c.revenu_annuel > 112500.00
order by c.revenu_annuel desc;


  -- rechercher tous les contrats d'un clients donné

select c.contrat_id,c2.nom ,c2.prenom ,c2.revenu_annuel ,c.date_signature,c.statut,c.date_cloture
from contrats c 
join clients c2 on c.client_id =c2.client_id
where c.client_id =26;

  -- 📊 Nombre de contrat par nom de  produit

select p.nom_produit , count(*) as nombre_de_contrat
from contrats c 
join produits p on p.produit_id = c.produit_id
group by p.nom_produit ;

   -- 📈  Évolution de la valeur d’un contrat dans le temps

select c.contrat_id ,c.date_signature,vc.valeur ,vc.date_valeur
from valeurs_contrat vc
inner join contrats c on c.contrat_id=vc.contrat_id
where vc.contrat_id =60;


   -- 📈  Évolution de la valeur des contrats dans le temps

select c.contrat_id ,c.date_signature,vc.valeur ,vc.date_valeur
from valeurs_contrat vc
join contrats c on c.contrat_id = vc.contrat_id
order by vc.date_valeur;


   -- 💸  Total des versements programmés par contrat et par frequence

select vp.contrat_id,vp.frequence ,SUM(vp.montant) as total_versement
from versements_programmes vp 
group  by vp.contrat_id,vp.frequence
order by vp.contrat_id ;

 	-- 🕵️  Liste des contrats avec sinistre (type + montant)


select c.contrat_id ,c.statut,s.type_sinistre,s.montant
from contrats c 
join sinistres s on c.contrat_id =s.contrat_id;

	-- 📋 Liste des contrats ayant subi un sinistre, avec le type, montant et nom du produit associé

select c.contrat_id,p.nom_produit ,c.statut,s.type_sinistre,s.montant
from contrats c 
join sinistres s on c.contrat_id =s.contrat_id
join produits p on c.produit_id=p.produit_id ;


 	-- 🧾  Dernière opération effectuée sur chaque contrat

select o.contrat_id,o.type_operation,o.montant ,o.date_operation
from operations o 
join(
select contrat_id, MAX(date_operation) as dernier_date_operation
from operations
group by contrat_id)last_operat on o.contrat_id =last_operat.contrat_id
and o.date_operation =last_operat.dernier_date_operation 
order by o.contrat_id;



-- ⚠️  Alertes de contrats actifs

SELECT a.contrat_id,a.type_alerte,a.message,a.date_alerte
FROM alertes_contrat a
join contrats c on a.contrat_id=c.contrat_id
where c.statut='Actif';