class LocalizacaoModel {
  final String cep;
  final String rua;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;
  // final String ibge;
  // final String gia;
  // final String ddd;
  // final String siafi;

  const LocalizacaoModel({
    required this.cep,
    required this.rua,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  factory LocalizacaoModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "cep": String cep,
        "logradouro": String logradouro,
        "complemento": String complemento,
        "bairro": String bairro,
        "localidade": String localidade,
        "uf": String uf,
      } =>
        LocalizacaoModel(
            bairro: bairro,
            cep: cep,
            complemento: complemento,
            localidade: localidade,
            rua: logradouro,
            uf: uf),
      _ => throw const FormatException('Failed to load location.'),
    };
  }
}
