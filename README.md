# data_analyst
data-analyst-work
# Base de données Assurance Vie
## Description
Cette base de données modélise les données essentielles liées aux contrats d’assurance vie. Elle comprend les informations sur les clients, les contrats, les bénéficiaires désignés, les événements liés aux contrats, ainsi que les intermédiaires impliqués.

## 🗂️ Tables principales

| Table                      | Description |
|---------------------------|-------------|
| `clients`                 | Informations sur les assurés |
| `produits`                | Types de produits d’assurance vie |
| `intermediaires`          | Canaux de souscription (agent, courtier…) |
| `contrats`                | Souscriptions d’assurance vie |
| `operations`              | Versements, rachats |
| `valeurs_contrat`         | Évolution des encours |
| `versements_programmes`   | Échéancier de versements |
| `sinistres`               | Événements impactant les contrats |
| `documents_contrat`       | Documents liés aux contrats |
| `alertes_contrat`         | Notifications ou rappels |
| `historique_statuts_contrat` | Suivi des statuts dans le temps |
| `beneficiaires`           | Personnes désignées en cas de décès |

# 🖼️ Schéma relationnel (Mermaid) 

https://www.mermaidchart.com/app/projects/506d24a8-e9c4-457b-b08f-eed1e73b1fd7/diagrams/19704dba-d7c7-4f45-b056-4156892d3aa2/share/invite/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkb2N1bWVudElEIjoiMTk3MDRkYmEtZDdjNy00ZjQ1LWIwNTYtNDE1Njg5MmQzYWEyIiwiYWNjZXNzIjoiRWRpdCIsImlhdCI6MTc1MDg1MTI2MH0.3sGaOEKVR9orxc4tDua60037Qphz_xhPrYvDcd4MNk0
