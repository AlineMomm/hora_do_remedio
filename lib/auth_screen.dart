import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  bool _isLogin = true;
  bool _showCustomLogo = false;

  void _toggleLogo() {
    if (!_isLogin) {
      setState(() {
        _showCustomLogo = !_showCustomLogo;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _showCustomLogo 
              ? 'Logo personalizada ativada!' 
              : 'Logo padrão ativada!'
          ),
          backgroundColor: _showCustomLogo ? Colors.green : Colors.blue,
        ),
      );
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        
        String message = _isLogin ? 'Login realizado!' : 'Cadastro realizado!';
        if (!_isLogin && _showCustomLogo) {
          message += ' Com logo personalizada!';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      });
    }
  }

  Widget _buildLogo() {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleLogo,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: _showCustomLogo ? const Color(0xFF4CAF50) : const Color(0xFFD32F2F),
                width: _showCustomLogo ? 4 : 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: _showCustomLogo ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: _showCustomLogo 
                ? _buildCustomLogo()
                : _buildDefaultLogo(),
          ),
        ),
        
        const SizedBox(height: 20),
        
        Text(
          'Hora do Remédio',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Lembretes inteligentes para sua saúde',
          style: TextStyle(
            color: const Color(0xFFE57373),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        
        // MENSAGEM INTERATIVA
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _showCustomLogo ? const Color(0xFFE8F5E8) : const Color(0xFFFFEBEE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _showCustomLogo ? Colors.green : const Color(0xFFFFCDD2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _showCustomLogo ? Icons.check_circle : Icons.touch_app,
                color: _showCustomLogo ? Colors.green : const Color(0xFFD32F2F),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                _isLogin 
                  ? 'Logo do App'
                  : _showCustomLogo 
                    ? 'Sua logo personalizada!' 
                    : 'Toque para usar sua logo!',
                style: TextStyle(
                  color: _showCustomLogo ? Colors.green : const Color(0xFFD32F2F),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomLogo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(21),
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Se não encontrar a imagem, mostra fallback
          return _buildLogoError();
        },
      ),
    );
  }

  Widget _buildLogoError() {
    return Container(
      color: const Color(0xFFFFF5F5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 40,
            color: Colors.orange,
          ),
          const SizedBox(height: 8),
          const Text(
            'Logo não\nencontrada',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.orange,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Verifique assets/images/',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultLogo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services,
            size: 50,
            color: _isLogin ? const Color(0xFFFFCDD2) : const Color(0xFFD32F2F),
          ),
          const SizedBox(height: 8),
          Text(
            _isLogin ? 'LOGO' : 'CLIQUE\nAQUI',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _isLogin ? const Color(0xFFFFCDD2) : const Color(0xFFD32F2F),
              fontSize: _isLogin ? 16 : 14,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          if (!_isLogin) ...[
            const SizedBox(height: 4),
            Text(
              'para usar sua\nlogo',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFE57373),
                fontSize: 10,
                height: 1.1,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildLogo(),
              const SizedBox(height: 40),
              
              // FORMULÁRIO
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (!_isLogin)
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nome completo',
                            prefixIcon: Icon(Icons.person, color: Color(0xFFD32F2F)),
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor, digite seu nome';
                            }
                            return null;
                          },
                        ),
                      if (!_isLogin) const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email, color: Color(0xFFD32F2F)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor, digite seu e-mail';
                          }
                          if (!value.contains('@')) {
                            return 'Por favor, digite um e-mail válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: Icon(Icons.lock, color: Color(0xFFD32F2F)),
                        ),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor, digite sua senha';
                          }
                          if (value.trim().length < 6) {
                            return 'A senha deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _submit(),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // BOTÃO DE AÇÃO
              if (_isLoading)
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD32F2F)),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      _isLogin ? 'Entrar' : 'Cadastrar',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              
              const SizedBox(height: 16),
              
              // BOTÃO DE ALTERNÂNCIA
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                    if (_isLogin) {
                      _showCustomLogo = false;
                    }
                  });
                },
                child: Text(
                  _isLogin 
                    ? 'Não tem conta? Cadastre-se' 
                    : 'Já tem conta? Entre aqui',
                  style: const TextStyle(
                    color: Color(0xFFD32F2F),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}