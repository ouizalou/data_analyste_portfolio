use assurance_vie;

---- 🏆 Classement des clients par montant total investi 

select c.client_id, c.nom,c.prenom,count( distinct ct.contrat_id)as nbre_contrat_investi,sum(vp.montant) as total_investi,
rank() over (order by SUM(vp.montant) desc) as rang_investiseur
from clients c 
join contrats ct on ct.client_id=c.client_id
join versements_programmes vp on vp.contrat_id=ct.contrat_id
group by c.client_id, c.nom,c.prenom;

-- 📆 Valeur moyenne mensuelle d’un contrat

select vc.contrat_id,DATE_FORMAT(vc.date_valeur,'%M - %Y') as mois,
avg(vc.valeur) as valeur_moyenne
from valeurs_contrat vc
group by vc.contrat_id,mois
order by vc.contrat_id;

-- 📈 Variation mensuelle (%) de la valeur d’un contrat
select vc.contrat_id,
  date_format (vc.date_valeur,'%M - %Y') as mois,
  -- 
 lag( vc.valeur) over(partition by vc.contrat_id order by vc.date_valeur) as valeur_precedente,
 case 
 	when lag( vc.valeur) over(partition by vc.contrat_id order by vc.date_valeur) is null then null
 when lag( vc.valeur) over(partition by vc.contrat_id order by vc.date_valeur) =0 then null 
 else round((vc.valeur-  lag( vc.valeur) over(partition by vc.contrat_id order by vc.date_valeur))/
 lag( vc.valeur) over(partition by vc.contrat_id order by vc.date_valeur) * 100 ,2)
 end as variation_pourcentage
from valeurs_contrat vc;


-- 💤 Contrats inactifs depuis plus d’un an

select c.contrat_id,c.date_signature,max(o.date_operation ) as dernier_operation,
datediff(curdate(),max(o.date_operation)) as nombre_jours
from contrats c
left join operations o on o.contrat_id=c.contrat_id
group by c.contrat_id
having nombre_jours >365; 


-- ⚠️ Contrats actifs avec sinistres > 10 000 €

select c.contrat_id, s.type_sinistre,s.montant
from contrats c
join sinistres s on s.contrat_id=c.contrat_id
where c.statut='Actif' and s.montant>10000;


-- 📊 Répartition des sinistres par produit

select c.contrat_id,p.nom_produit,s.type_sinistre,count(s.sinistre_id) as nombre_sinistre,
avg(s.montant)as montant_moyen
from sinistres s 
join contrats c  on c.contrat_id=s.contrat_id
join produits p on p.produit_id=c.produit_id
group by c.contrat_id,s.type_sinistre,p.nom_produit
order by nombre_sinistre desc ;

-- 🧾 Dernière alerte par contrat actif

select contrat_id, type_alerte, message, date_alerte
from (
select a.contrat_id,a.type_alerte,a.message, a.date_alerte,
row_number() over( partition by a.contrat_id order by a.date_alerte desc) as rang
from alertes_contrat a
join contrats c on c.contrat_id=a.contrat_id
where c.statut='Actif')latest
WHERE rang = 1;


