# TKC-PAR-0016 — Avaliação de capacidade e viabilidade do piloto M3-02

task_id: TKC-0016
order_id: TKC-0016-O01
claim_id: TKC-0016-C01
autor intelectual / registro: AGT-004 — Backend (ChatGPT; identificação funcional, não prova de capacidade)
publicação técnica: conector GitHub desta sessão; identidade técnica conforme commit
revisor proposto: AGT-002 — QA / Segurança / Auditoria, sessão distinta
destinatário: AGT-001 III
data: 2026-11-28 (RELATADO)
decision_ref: TKC-REQ-0016 @c92e530433707c167c85c5d93f8df8de8eb87c99 #TRUE
authorization_provenance: MEDIADO — HUMAN-001, mensagem desta sessão; autorização documental restrita aos três caminhos da ordem
base_commit: 6dff9dd8317a47ae80bfb69e36db096fa96f1450
rules_checked_commit: 6dff9dd8317a47ae80bfb69e36db096fa96f1450
rules_scope: AGENTS.md, IA/PROJETO.md, COM-001 v0.3.0, COM-002, IA/regras/seguranca.md, índice
rules_check_status: ATUALIZADO no escopo consultado
claim_remote_confirmed: 6ccd4aa3e82163a151dbb6a3d57d76d49703349d
nível: análise L0/L1 e publicação documental L2; execução de produto NÃO AUTORIZADA
decisão: VIAVEL_COM_CONDICOES — objeto tecnicamente adequado; capacidade de execução de testes ainda DESCONHECIDA; NÃO LIBERAR PILOTO

## 1. Evidência direta de acesso e revisão

VERIFICADO: a referência curta c92e530 resolveu inequivocamente a c92e530433707c167c85c5d93f8df8de8eb87c99, commit que publicou a ordem. Comparação até 6dff9dd8317a47ae80bfb69e36db096fa96f1450 mostrou somente mudanças em IA/tarefas/TKC-0015.md e índice; C05 entregue, sem alteração material da ordem ou do objeto. O HEAD foi consultado novamente antes do claim, e o claim foi publicado e relido no remoto antes de escrever este parecer. Não há lock atômico.

Fontes primárias na revisão 6dff9dd8317a47ae80bfb69e36db096fa96f1450:
- [AGENTS.md](https://github.com/edinhogrubert/TeamKitCollection/blob/6dff9dd8317a47ae80bfb69e36db096fa96f1450/AGENTS.md)
- [IA/PROJETO.md](https://github.com/edinhogrubert/TeamKitCollection/blob/6dff9dd8317a47ae80bfb69e36db096fa96f1450/IA/PROJETO.md)
- [COM-001 v0.3.0](https://github.com/edinhogrubert/TeamKitCollection/blob/6dff9dd8317a47ae80bfb69e36db096fa96f1450/IA/regras/comunicacao.md)
- [COM-002](https://github.com/edinhogrubert/TeamKitCollection/blob/6dff9dd8317a47ae80bfb69e36db096fa96f1450/IA/despachos/README.md)
- [segurança](https://github.com/edinhogrubert/TeamKitCollection/blob/6dff9dd8317a47ae80bfb69e36db096fa96f1450/IA/regras/seguranca.md)
- [índice](https://github.com/edinhogrubert/TeamKitCollection/blob/6dff9dd8317a47ae80bfb69e36db096fa96f1450/IA/tarefas/indice.md)
- [TKC-0016](https://github.com/edinhogrubert/TeamKitCollection/blob/6dff9dd8317a47ae80bfb69e36db096fa96f1450/IA/tarefas/TKC-0016.md)
- [TKC-0015 C05](https://github.com/edinhogrubert/TeamKitCollection/blob/6dff9dd8317a47ae80bfb69e36db096fa96f1450/IA/tarefas/TKC-0015.md)
- [ordem imutável](https://github.com/edinhogrubert/TeamKitCollection/blob/c92e530433707c167c85c5d93f8df8de8eb87c99/IA/despachos/ordens/TKC-REQ-0016.md)
- [teste unitário](https://github.com/edinhogrubert/TeamKitCollection/blob/6dff9dd8317a47ae80bfb69e36db096fa96f1450/tests/unit/test_health_unit.py), blob a165e47889ddcc99c026a2562914336f9077738a.

## 2. Capacidade por função e sessão

| Capacidade | Estado | Evidência / limite |
|---|---|---|
| Leitura remota | VERIFICADO | HEAD completo, resolução de revisão, leitura direta do teste e regras, comparação de commits acima |
| Escrita remota documental | VERIFICADO | entrega anterior desta conversa 9c8bbb299c61fca00f980f3d783dc6d53a7df545, verificada no Git; adicionalmente claim atual 6ccd4aa3e82163a151dbb6a3d57d76d49703349d publicado e relido; publicação deste parecer é evidência adicional após verificação |
| Identidade/autorização humana | MEDIADO | decisão recebida nesta sessão referenciando revisão exata e caminhos; não prova criptográfica de identidade |
| Execução de Python/pytest em checkout isolado do projeto | DESCONHECIDO | não há evidência reproduzível nesta sessão de execução deste comando com o código e dependências corretos; capacidade genérica de ferramenta não prova ambiente apto |
| Dependências instaladas, versão Python e pytest no ambiente candidato | DESCONHECIDO | nenhuma inspeção por comando ou instalação efetuada nesta REQ |
| Docker, VM, PostgreSQL, rede | NÃO EXECUTADO / fora do escopo | desnecessários para o teste mockado; não reivindicar acesso |
| Revisão independente | PENDENTE | AGT-002 proposto; sua capacidade e autorização devem ser verificadas separadamente |

A falta de evidência de testes bloqueia atribuição executiva do piloto, não a entrega documental desta avaliação. Não confundir a publicação do claim com prova de execução de código. Não houve ensaio descartável nem criação de branch.

## 3. Viabilidade do objeto — inspeção estática

O teste existente possui três funções: sucesso, indisponibilidade com Exception e mensagem sintética, e recuperação com side_effect [None, OSError("falha"), None]. O caso de indisponibilidade verifica 503, JSON exato e ausência da mensagem sintética no corpo, mas não parametriza Exception/OSError nem verifica chamada única nesse caso. O caso de sucesso já verifica chamada única. O objeto é pequeno e compatível com a finalidade do piloto: melhorar evidência unitária sem alterar comportamento do produto.

Intervenção candidata exclusivamente em tests/unit/test_health_unit.py: importar pytest, parametrizar a função test_health_unavailable_does_not_leak_secret para Exception e OSError, usar a mesma mensagem sintética (não segredo real), instanciar a exceção por caso, capturar mock_check com "as", manter as asserções existentes e acrescentar mock_check.assert_called_once(). Preservar integralmente os testes de sucesso e recuperação e imports necessários. Não alterar main.py, db.py, configuração, dependências, Dockerfile, Compose, scripts, normas ou demais arquivos. Nenhum patch foi produzido ou executado nesta REQ. A contagem esperada por inspeção é quatro casos coletados após parametrização (antes três), não resultado observado.

Comando candidato, a partir da raiz de uma cópia isolada da revisão aprovada:
`python -m pytest -q tests/unit/test_health_unit.py`
A função check_database é substituída no namespace src.backend.main; a intenção do teste é não acessar PostgreSQL nem rede externa. TestClient opera in-process. A inspeção do arquivo não comprova isolamento efetivo do ambiente/imports; verificar previamente dependências, arquivos de configuração de pytest e ausência de plugins/fixtures/hooks inesperados, e impor ausência de rede externa em ambiente de teste quando tecnicamente disponível. Não usar credenciais reais nem VM de produção.

## 4. Ensaio mínimo separado para fechar lacuna de capacidade (PROPOSTO, NÃO AUTORIZADO)

Antes de AUT do patch, AGT-001 deve obter autorização específica para uma sessão executora apta realizar apenas ensaio de capacidade, sem modificar produto ou Git de produto. Definir revisão imutável, ambiente de trabalho descartável isolado com cópia do repositório autorizada previamente (sem aquisição de dependências ou acesso externo de teste), caminhos locais e documentação de evidência explicitamente autorizados. Não reutilizar artefatos do incidente TKC-0004-C03. Não criar branch descartável remota por padrão: escrita já comprovada nesta sessão.

Proposta de sequência autorizável: confirmar checkout limpo e SHA; verificar Python e disponibilidade de pytest/FastAPI/httpx/psycopg sem instalar; executar comando candidato sobre o teste original intacto, sem rede externa, Docker ou banco. Registrar ambiente, versões, comando, stdout/stderr sanitizados, código de retorno e diff/status antes/depois; arquivos temporários de cache/bytecode limitados à cópia descartável (ou desabilitados). Para evitar plugins externos inesperados, avaliar PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 e opções de cache/bytecode, documentando comando efetivo e equivalência ao candidato. Se dependência ausente, isolamento não verificável, teste falhar ou não houver ambiente apto, parar e publicar impedimento no caminho documental previamente autorizado, sem instalar ou modificar produto. O teste original deve coletar três casos e passar; isso demonstrará capacidade para aquela sessão/ambiente, não aceite do patch. Caso não haja capacidade nesta sessão, designar executor apto mediante nova decisão e verificação; não presumir transferência de autorização.

Escopo documental do ensaio deve ser explicitado por AGT-001 em ordem própria (por exemplo, atualização de IA/tarefas/TKC-0016.md, linha própria de IA/tarefas/indice.md e complemento de IA/despachos/retornos/TKC-PAR-0016.md, se escolhidos). Nenhum desses caminhos fica autorizado para nova tentativa por este parecer. Não criar novo arquivo de evidência sem autorização exata.

## 5. Critérios futuros do piloto

- AUT versionada, decisão humana vinculada a SHA, escopo de produto único tests/unit/test_health_unit.py, escopo documental explicitado, executor e revisor distintos, evidência de capacidade aplicável e claim remoto antes de alteração.
- Diff restrito ao teste proposto e documentação autorizada; preservar histórico e não reintegrar incidente anterior.
- Quatro casos esperados: sucesso 200; indisponibilidade Exception 503; indisponibilidade OSError 503; recuperação 200/503/200. Nos dois casos de indisponibilidade, JSON exato {"status":"unhealthy","database":"down","error":"DB_UNAVAILABLE"}, mensagem sintética ausente da resposta e mock chamado exatamente uma vez. Código de retorno zero e saída reproduzível exigidos. Não confundir quatro casos esperados com quatro casos executados.
- Evidência do comando, ambiente, SHA, diff, isolamento e resultado; revisão independente AGT-002 sobre Git e evidências, sem autoaprovação; decisão humana separada.
- Caso negativo do método: falta de capacidade, autorização ou posse implica parada antes de produto, sem tentativa local alternativa; evidência por referência e motivo curto, sem colagem integral.
- Métricas esforço de construção/método, intervenções, retrabalho e custo efetivo: NÃO MEDIDO nesta avaliação. Limite adicional R$ 0,00; nenhuma contratação/provisionamento.

## 6. Riscos e conclusão

Riscos INFERIDOS: incompatibilidade das faixas de dependências, ausência de ambiente de teste, configuração/plugins com efeitos colaterais, execução em revisão errada e concorrência no índice. Mitigações propostas: gate de capacidade, ambiente isolado, revisão imutável, verificação de diff e claim cooperativo confirmado, revisão distinta. Nenhum risco foi reproduzido como falha. Testes efetivamente executados: zero. Código/infraestrutura alterados: zero. Nenhuma instalação, rede de teste, Docker, PostgreSQL, VM ou branch criada.

VIAVEL_COM_CONDICOES para o objeto; BLOQUEIO OPERACIONAL por capacidade de teste não comprovada e ausência de AUT de execução. Entrega documental C01 para EM_REVISAO, posse encerrada; não iniciar piloto, não concluir TKC-0016 ou M3-02. Próximo passo: AGT-001 avaliar e autorizar separadamente ensaio de capacidade ou atribuir sessão comprovadamente apta; revisão QA distinta. O SHA de entrega será obtido do histórico Git, sem hash autorreferente.


---

# C03 — Resultado do gate de capacidade CAP

**Autor intelectual e registro:** AGT-004 — Backend, mesma conversa C01 (RELATADO).
**Publicação técnica:** conector GitHub desta sessão, identidade técnica conforme commit.
**Ordem:** TKC-AUT-0016-CAP revisão 1, 67f1e375943e3c0cf12d0def9b9d7fa9f9591f2c.
**Decisão:** HUMAN-001 enviou TKC-AUT-0016-CAP @67f1e37 #TRUE nesta conversa; proveniência MEDIADO. Escopo exclusivo de ensaio CAP condicionado e três caminhos documentais, sem patch.
**Base remota de coordenação:** 9469255020a1edc65fbd533981530a12f114a334.
**Revisão imutável exigida para ensaio:** 706cda089731263ee4f0b5e48e2bfe06047f57ef.
**Claim documental C03:** 3fe790a06bf3513200f1fd99b3ea5b824b30c656, confirmado e relido no remoto antes desta publicação.
**Resultado:** BLOQUEADA — checkout local previamente disponível não localizado; capacidade de teste continua DESCONHECIDA.

## Evidências e parada

- VERIFICADO: SHA curto 67f1e37 resolvido ao SHA completo acima; comparação Git até a base de coordenação mostra somente registro TKC-0016, índice e ata documental, sem alteração da AUT, produto ou regras. COM-001 v0.3.0 e COM-002 revalidados. C02 entregue, sem posse ativa conflitante identificada. Escrita documental confirmada pelo claim C03.
- VERIFICADO por inspeção local somente leitura: diretório corrente /; /mnt/data sem checkout; busca limitada a profundidade 4 por diretórios/entradas .git ou nome TeamKitCollection nos caminhos disponíveis /home/oai, /workspace, /workspaces, /app, /root, /opt, /mnt e /tmp não localizou checkout do projeto. As únicas entradas .git observadas nessa busca foram /opt/novnc/.git e /opt/nvm/.git, alheias ao projeto. Esta evidência não prova inexistência universal de cópia em outros ambientes ou caminhos inacessíveis; prova que nenhuma cópia apta foi identificada nesta sessão. A checagem de disponibilidade precedeu o claim documental e não iniciou ensaio nem alterou arquivos.
- Não foi possível verificar localmente limpeza, SHA, blob original a165e47889ddcc99c026a2562914336f9077738a, configuração pytest, dependências, ausência de credenciais e isolamento de rede de uma cópia adequada. Esses pré-requisitos permanecem DESCONHECIDOS para o ambiente do ensaio. Não se usou acesso Git remoto para adquirir checkout, reconstruir código ou criar branch.
- Comando autorizado, NÃO EXECUTADO: `PYTHONDONTWRITEBYTECODE=1 PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 python -m pytest -q -p no:cacheprovider tests/unit/test_health_unit.py`. Sem stdout/stderr de pytest, sem código de retorno, sem contagem observada, sem PASS/FALHA de teste. Três casos aprovados era expectativa, não resultado.
- Nenhuma cópia criada, instalação, patch, alteração de produto, rede de teste, Docker, PostgreSQL, VM, configuração, credencial ou branch. Não houve execução local alternativa. Métricas de esforço, intervenções, retrabalho e custo efetivo: NÃO MEDIDO; nenhum provisionamento ou contratação.
- C03 documenta impedimento; não declara falha do backend nem incapacidade definitiva da plataforma. Leitura/escrita Git continuam VERIFICADAS, mas não comprovam capacidade pytest.

## Próximo passo

AGT-001 deve coordenar sessão com checkout isolado previamente disponível na revisão exigida, ou propor autorização distinta para disponibilização controlada de uma cópia e ensaio com evidência de isolamento. Não presumir que autorização CAP atual permite aquisição de código pela rede. Revalidar capacidade, autorização e posse antes de nova tentativa; não transferir autorização automaticamente. Nenhum patch ou piloto liberado. Revisão QA e decisão humana separadas. M3-02 permanece PENDENTE. C03 encerrada sem posse ativa, tarefa BLOQUEADA.


---

# C06 — Evidência humana CAP R03 e encaminhamento R04

- Ordem CAP R03 @9f286f9590195192d977229b8a4fac7394e10c06, autorizada por HUMAN-001 #TRUE. Script @fd6b4d5cf702de73762ddd215ade765660be3107. Execução humana na VM local, resultado MEDIADO, não execução de agente. Terminal fornecido:

```text
TKC-0016 CAP R03 | execução HUMAN-001 | custo adicional permitido R$ 0,00
CAP=BLOQUEADA | Isolamento de rede indisponível; sem tentativa alternativa ou sudo.
```

- Conforme comando informado com set -e, a chegada ao script indica download, hash e sintaxe bem-sucedidos. Isolamento por unshare indisponível. Dependências não verificadas, pytest não iniciado; não é falha de backend. Nenhuma alteração de produto ou custo indicado; custo efetivo NÃO MEDIDO. R03 encerrada BLOQUEADA, autorização consumida. A evidência não comprova capacidade própria de AGT-004.
- Coordenação C06, autorizada por HUMAN-001 #TRUE MEDIADO na base 5e4824ebb823d97ddc58c896389efcaa240e54a4, reivindicação ba74bbd90daf4b7b5f47a891cf7ee3f188606e9a confirmada: propõe CAP R04 com Docker exclusivamente local e imagem já existente, sem rede de teste, pull, build, instalação, mudança de permissões do host ou contêineres existentes. Script 6d9b0a0051b179e3b1e8ea6b528dbfafd39e736c, ordem bccc7dfea08ad55eac6ff80fb5451cd3cb325d1d. R04 aguarda autorização específica. Disponibilidade da imagem e dependências desconhecida; script sem teste funcional/revisão independente. M3-02 PENDENTE.
