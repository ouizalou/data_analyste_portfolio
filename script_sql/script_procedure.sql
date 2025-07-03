use assurance_vie;

-- procedure pour afficher les contrats d'un clients donné

DELIMITER //
create procedure get_contrats_client(in p_client_id int)
begin
	select c.contrat_id,cl.nom,cl.prenom,c.date_signature,c.statut,
	i.intermediaire_id,i.nom,i.prenom,
	b.nom,b.lien,b.pourcentage,
	sum(vp.montant) as total_investi
	from contrats c
	join clients cl on cl.client_id=c.client_id
	join intermediaires i on i.intermediaire_id=c.intermediaire_id
	join beneficiaires b on b.contrat_id=c.contrat_id
	left join versements_programmes vp on vp.contrat_id=c.contrat_id
	where c.client_id=p_client_id
	group by c.contrat_id, c.date_signature, c.statut,cl.nom,cl.prenom,i.intermediaire_id,i.nom,
i.prenom,b.nom,b.lien,b.pourcentage;
end; 
//
DELIMITER ;

-- appel de la procedure

call get_contrats_client(9);
call get_contrats_client(34);
call get_contrats_client(23);

-- procedure pour afficher la liste des sinistres pour un contrat donné

delimiter 
//
create procedure get_sinistre_contrat(in p_contrat_id int)
begin
	select c.contrat_id,s.sinistre_id,s.type_sinistre,s.date_sinistre,s.montant,
	cl.nom as nom_client,cl.prenom as prenom_client,c.date_signature,c.statut,
	i.intermediaire_id,i.nom as nom_intermediaire,i.prenom as prenom_intermediaire,
	p.nom_produit,p.type_produit
	from contrats c
	join clients cl on cl.client_id=c.client_id
	join produits p on p.produit_id=c.produit_id
	join intermediaires i on  i.intermediaire_id=c.intermediaire_id
	join sinistres s on s.contrat_id=c.contrat_id

	where c.contrat_id=p_contrat_id; 
end
//
delimiter 

call get_sinistre_contrat(165);
call get_sinistre_contrat(72);


--  procedure pour retracer l’historique des statuts d’un contrat

delimiter //
create procedure get_historique_statuts_contrat(in p_contrat_id int)
begin
	select c.contrat_id,c.date_signature, h.statut,h.date_statut
	from contrats c
	join historique_statuts_contrat h on h.contrat_id=c.contrat_id
	where c.contrat_id=p_contrat_id
	order by h.date_statut;
end;
//
delimiter;

call get_historique_statuts_contrat(23);
call get_historique_statuts_contrat(84);
call get_historique_statuts_contrat(64);

--  procedure pour retracer  l'historique des statuts de tous les contrats d'un client donné


delimiter //
create procedure get_historique_statuts_contrat_client(in p_client_id int)
begin
	select c.contrat_id,cl.nom,cl.prenom,
	c.date_signature, h.statut,h.date_statut
	from clients cl
	join contrats c on c.client_id=cl.client_id
	join historique_statuts_contrat h on h.contrat_id=c.contrat_id
	
	where c.client_id=p_client_id
	order by h.date_statut;
end;
//
delimiter ;

call get_historique_statuts_contrat_client(23);



--  procedure pour afficher l'evolution d'une valeur d'un contrat dans le temps


delimiter //

create procedure get_valeurs_contrat(in p_contrat_id int)
begin
	select c.contrat_id,c.capital_initial,
	op.type_operation, op.date_operation,op.montant,
	vc.valeur,vc.date_valeur
	from contrats c 
	join valeurs_contrat vc on vc.contrat_id=c.contrat_id
	join operations op on op.contrat_id=c.contrat_id
	where c.contrat_id=p_contrat_id
	order by op.date_operation,vc.date_valeur;
end;
//
delimiter ;

call get_valeurs_contrat(183);



