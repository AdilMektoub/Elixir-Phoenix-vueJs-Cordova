alias Theme01.Repo
alias Theme01.Management.Team

Repo.insert! %Team{
    name: "La team cookie",
    manager_id: 5
}

Repo.insert! %Team{
    name: "La team ananas",
    manager_id: 4
}

Repo.insert! %Team{
    name: "La team banane",
    manager_id: 3
}

Repo.insert! %Team{
    name: "La team pomme",
    manager_id: 4
}
