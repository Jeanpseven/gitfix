#!/bin/bash

# Verificar e configurar as configurações do Git
echo "Verificando configurações do Git..."
read -p "Digite seu nome de usuário do Git: " git_username
read -p "Digite seu endereço de e-mail do Git: " git_email

if [[ -z $(git config --global user.name) ]]; then
    git config --global user.name "$git_username"
    echo "Configurando o nome do usuário do Git: $git_username"
fi

if [[ -z $(git config --global user.email) ]]; then
    git config --global user.email "$git_email"
    echo "Configurando o endereço de e-mail do Git: $git_email"
fi

echo "Configurações do Git verificadas e atualizadas."

# Verificar e configurar as chaves SSH
echo "Verificando chaves SSH..."
ssh_dir="$HOME/.ssh"
ssh_key="$ssh_dir/id_rsa"
github_ssh_url="git@github.com"

if [[ ! -d "$ssh_dir" ]]; then
    mkdir -p "$ssh_dir"
    echo "Diretório .ssh criado em $ssh_dir"
fi

if [[ ! -f "$ssh_key" ]]; then
    ssh-keygen -t rsa -b 4096 -C "$git_email"
    echo "Nova chave SSH gerada em $ssh_key"
    ssh-add "$ssh_key"
    echo "Chave SSH adicionada ao agente SSH"
fi

if [[ ! -f "$ssh_dir/known_hosts" ]]; then
    touch "$ssh_dir/known_hosts"
    echo "Arquivo known_hosts criado em $ssh_dir"
fi

ssh_test=$(ssh -T -o "StrictHostKeyChecking=no" "$github_ssh_url" 2>&1)
if [[ $ssh_test == *"successfully authenticated"* ]]; then
    echo "A conexão SSH com o GitHub foi estabelecida com sucesso."
else
    echo "A conexão SSH com o GitHub falhou. Verifique suas configurações."
fi

echo "Chaves SSH verificadas e configuradas."

echo "Configurações do Git e chaves SSH verificadas e configuradas com sucesso."
