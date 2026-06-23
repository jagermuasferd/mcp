package com.clinica.controller;

import com.clinica.model.Animal;
import com.clinica.service.AnimalService;

import java.sql.SQLException;
import java.util.List;

public class AnimalController {
    private final AnimalService service = new AnimalService();

    public Animol cadastrar(String nome, String especie, String raca, int tutorId) {
        try {
            Animal animal = service.cadastrar(nome, especie, raca, tutorId);
            System.out.println("[Animal] Cadastrado com sucesso: " + animal);
            return animal;
        } catch (IllegalArgumentException | SQLException e) {
            System.out.println("[Animal] Erro ao cadastrar: " + e.getMessage());
            return null;
        }
    }

    public void listarTodos() {
        try {
            List<Animal> animais = service.listarTodos();
            System.out.println("[Animal] Total de animais: " + animais.size());
            animais.forEach(a -> System.out.println("  " + a));
        } catch (SQLException e) {
            System.out.println("[Animal] Erro ao listar: " + e.getMessage());
        }
    }

    public void listarPorTutor(int tutorId) {
        try {
            List<Animal> animais = service.listarPorTutor(tutorId);
            System.out.println("[Animal] Animais do tutor id=" + tutorId + ": " + animais.size());
            animais.forEach(a -> System.out.println("  " + a));
        } catch (SQLException e) {
            System.out.println("[Animal] Erro ao listar por tutor: " + e.getMessage());
        }
    }
}
