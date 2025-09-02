#!/bin/bash

# Script de Git automatizado con soporte de GitHub CLI y autocompletado

# Función para listar ramas locales
function listar_ramas() {
    git branch --all
}

# Función para crear una rama nueva
function crear_rama() {
    echo "Nombre de la nueva rama: "
    read -e -i "nueva-rama" nueva_rama  # habilita autocompletado de nombres de archivo
    git checkout -b "$nueva_rama"
    echo "Rama '$nueva_rama' creada y activada."
}

# Función para eliminar una rama
function eliminar_rama() {
    ramas=($(git branch --format='%(refname:short)'))
    echo "Ramas disponibles:"
    for r in "${ramas[@]}"; do echo " - $r"; done
    echo "Nombre de la rama a eliminar: "
    read -e -i "${ramas[0]}" rama_eliminar
    git branch -d "$rama_eliminar"
    echo "Rama '$rama_eliminar' eliminada localmente."
    echo "Si deseas eliminar la rama remota, ejecuta: git push origin --delete $rama_eliminar"
}

# Función para hacer merge de una rama a main
function merge_a_main() {
    ramas=($(git branch --format='%(refname:short)'))
    echo "Ramas disponibles para merge en main:"
    for r in "${ramas[@]}"; do
        [ "$r" != "main" ] && echo " - $r"
    done
    echo "Nombre de la rama a fusionar en main: "
    read -e -i "${ramas[1]}" rama_merge
    git checkout main
    git merge "$rama_merge"
    git push origin main
    echo "Rama '$rama_merge' fusionada en main y enviada al remoto."
}

# Función para configurar Git en el directorio
function configurar_git() {
    echo "Inicializando Git en $(pwd)..."
    git init

    # Configurar rama principal
    git branch -M main

    # Crear commit inicial si no hay ninguno
    if [ -z "$(git rev-parse --verify HEAD 2>/dev/null)" ]; then
        git add .
        git commit -m "Commit inicial"
    fi

    # Autenticación con GitHub CLI
    gh auth status >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        gh auth login
    fi

    echo "Selecciona acción sobre el repositorio remoto:"
    echo "1) Crear repositorio remoto"
    echo "2) Actualizar URL del remoto existente"
    echo "3) Eliminar repositorio remoto"
    read -p "Opción [1-3]: " -e -i "1" opcion_remoto

    case $opcion_remoto in
        1)
            repo_name=$(basename "$PWD")
            read -p "Ingresa nombre del repo en GitHub (enter = mismo que carpeta): " -e -i "$repo_name" repo_name
            gh repo create "$repo_name" --public --source=. --push
            echo "Repositorio '$repo_name' creado y sincronizado."
            ;;
        2)
            remote_url=$(gh repo view --json sshUrl -q ".sshUrl")
            git remote set-url origin "$remote_url"
            echo "URL del remoto actualizada."
            ;;
        3)
            repos=$(gh repo list --json name -q '.[].name')
            echo "Repositorios disponibles: $repos"
            read -p "Ingresa nombre del repo en GitHub a eliminar: " -e repo_del
            read -p "Confirmar eliminación de '$repo_del'? (s/N): " -e confirm
            if [[ $confirm == [Ss] ]]; then
                gh repo delete "$repo_del" --yes
                echo "Repositorio '$repo_del' eliminado."
            fi
            ;;
    esac
}

# Menú principal
while true; do
    echo "=============================="
    echo "MENU DE GIT AUTOMATIZADO"
    echo "=============================="
    echo "1) Crear una nueva rama"
    echo "2) Eliminar una rama"
    echo "3) Hacer merge de una rama a main"
    echo "4) Listar ramas y estructura de directorios"
    echo "5) Configurar Git en este directorio"
    echo "6) Salir"
    echo "=============================="
    read -p "Selecciona una opción [1-6]: " opcion

    case $opcion in
        1) crear_rama ;;
        2) eliminar_rama ;;
        3) merge_a_main ;;
        4) listar_ramas ;;
        5) configurar_git ;;
        6) echo "Saliendo..."; exit 0 ;;
        *) echo "Opción no válida." ;;
    esac
done

