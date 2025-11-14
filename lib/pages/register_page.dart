import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool loading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final pink = Colors.pink.shade300;
    final pinkDark = Colors.pink.shade400;

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.shade100,
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Icon(Icons.auto_awesome, size: 70, color: pink),
                  const SizedBox(height: 12),
                  Text(
                    "Criar Conta",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: pinkDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Junte-se a nós",
                    style: TextStyle(fontSize: 16, color: Colors.pink.shade300),
                  ),
                  const SizedBox(height: 32),

                  TextFormField(
                    controller: emailCtrl,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      prefixIcon: Icon(Icons.email, color: pink),
                      filled: true,
                      fillColor: Colors.pink.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Informe o e-mail" : null,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Senha",
                      prefixIcon: Icon(Icons.lock, color: pink),
                      filled: true,
                      fillColor: Colors.pink.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Informe a senha";
                      if (v.length < 6) return "Mínimo 6 caracteres";
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: confirmCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirmar senha",
                      prefixIcon: Icon(Icons.lock_outline, color: pink),
                      filled: true,
                      fillColor: Colors.pink.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (v) {
                      if (v != passCtrl.text) return "As senhas não coincidem";
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),

                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pink,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: loading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;
                              setState(() => loading = true);

                              final auth = Provider.of<AuthService>(
                                context,
                                listen: false,
                              );
                              final error = await auth.signUp(
                                email: emailCtrl.text.trim(),
                                password: passCtrl.text.trim(),
                              );

                              setState(() => loading = false);

                              if (error != null) {
                                setState(() => errorMessage = error);
                              } else {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/home',
                                );
                              }
                            },
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Criar conta",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: Text(
                      "Já tem conta? Entrar",
                      style: TextStyle(color: pinkDark, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
