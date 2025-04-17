select * from informaticien where ville in ("Casabalanca", "Agadir", "Tanger", "Rabat");

select * from informaticien order by  DateNaissance DESC;

select * from informaticien where Salaire between 9000.00 and 12000.00;

select * from informaticien where ville = "Casablanca" order by Fonction desc , salaire; 

select * from informaticien where NomInf like 's%' and PrenomInf like '%e_';

select avg(salaire) as average_salaire from informaticien;

select avg(salaire) as salaire_moyen_infographiste from informaticien where Fonction = 'Infographiste';

select min(salaire) as minimum_salaire , max(salaire) as maximum_salaire from informaticien;

select count(*) as nombre from informaticien where fonction = "Analyste";

select fonction, count(*) as nombre from informaticien group by Fonction;

select fonction, avg(salaire) as salaire_moyen, count(*) as nombre from informaticien group by Fonction;

select * from informaticien where Salaire > (select avg(Salaire) from informaticien); 

select fonction, min(salaire), max(salaire) from informaticien group by fonction;

select * from informaticien where Fonction = "Analyste" and  Salaire > (select avg(Salaire) from informaticien);

select NomInf, Salaire, Fonction from informaticien where salaire > (select Salaire from informaticien where NomInf = "Faouzi");

select p.NumProjet, p.DateDebut, p.DateFin, t.NomTheme from projet as p inner join theme as t on p.NumTheme = t.NumTheme;

select NomTheme, count(CodeProjet) as count_projects from theme, projet where theme.NumTheme = projet.NumTheme group by NomTheme;

select NumProjet, NomTheme from projet p inner join theme t on p.NumTheme = t.NumTheme and NomTheme in ("Big data", "IA");





