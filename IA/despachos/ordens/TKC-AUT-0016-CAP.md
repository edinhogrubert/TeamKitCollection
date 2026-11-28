# TKC-AUT-0016-CAP — Proposta de autorização do ensaio de capacidade

task_id: TKC-0016
order_id: TKC-0016-O02
short_ref: TKC-AUT-0016-CAP
revision: 1 (SHA completo da ordem resolvido após publicação)
request_type: AUT — ensaio de capacidade, não execução do patch
recipient / executor: AGT-004 — Backend, mesma sessão C01; revalidar capacidade e atribuição
reviewer: AGT-002 — QA / Segurança / Auditoria (sessão distinta; revisão depende de autorização própria)
sender: AGT-001 III — coordenador
intellectual_author / recorded_by: AGT-001 III (ChatGPT / GPT-6.2 AUTODECLARADO)
status: PENDENTE — publicação da proposta não constitui autorização ou recebimento
authorization_state: PENDENTE
authorization_provenance: futura decisão HUMAN-001; MEDIADO no Git
decision_ref: TKC-AUT-0016-CAP @SHA #TRUE somente após decisão humana específica
repository / branch: edinhogrubert/TeamKitCollection / main
base_commit: 706cda089731263ee4f0b5e48e2bfe06047f57ef
task_record: IA/tarefas/TKC-0016.md
product_scope_paths: nenhum para escrita local ou remota no produto
documentation_scope_paths (propostos, não autorizados): IA/tarefas/TKC-0016.md; IA/tarefas/indice.md (somente linha TKC-0016); IA/despachos/retornos/TKC-PAR-0016.md (somente acrescentar seção de ensaio; preservar C01)
return_path: IA/despachos/retornos/TKC-PAR-0016.md
log_path: eventos na tarefa, sem arquivo separado
risk / cost_limit: L2 controlada (ensaio local e documentação), sem alteração de produto; R$ 0,00 adicional
capability_evidence: leitura/escrita documental C01, claim 6ccd4aa, entrega 706cda0; execução de testes DESCONHECIDA
dependencies: C02 preparação entregue, sem posse ativa ou conflito; COM-001 v0.3.0; TKC-PAR-0016 VIAVEL_COM_CONDICOES
stop_condition: se capacidade, ambiente, autorização, escopo ou posse não confirmados, BLOQUEADA; sem execução local alternativa ou modificação de produto

## Escopo do ensaio, condicionado a autorização
Usar somente uma cópia local descartável e isolada, previamente disponível, do repositório na revisão imutável 706cda089731263ee4f0b5e48e2bfe06047f57ef. Cópia local de checkout já disponível pode ser feita em diretório temporário exclusivo da sessão, sem alterar o original; registrar caminho, SHA e identidade do ambiente. Não adquirir checkout pela rede, não instalar dependências, não criar branch remota, não usar credenciais reais nem modificar arquivos de produto. Não reutilizar artefatos do incidente anterior. A autorização, se concedida, abrange somente essa cópia e arquivos temporários estritamente necessários nela; desabilitar cache e bytecode. Se não houver cópia adequada ou isolamento verificável, parar. Consultas e publicação dos registros Git autorizados são distintas do ambiente de testes, que deve ficar sem rede externa. Não alterar configurações de rede ou infraestrutura para obter isolamento.

## Procedimento
1. Revalidar HEAD, revisão da AUT, escopo, atribuição e conflitos. Confirmar a reivindicação remota de nova tentativa antes de iniciar o ensaio.
2. Confirmar cópia limpa, SHA exato e blob original a165e47889ddcc99c026a2562914336f9077738a em tests/unit/test_health_unit.py. Verificar disponibilidade de Python, pytest, FastAPI, httpx e psycopg sem instalar; inspecionar configuração pytest, conftest, imports e possíveis efeitos colaterais. Confirmar ausência de rede externa e de credenciais reais no ambiente de testes. Se não conseguir, parar.
3. Na raiz da cópia, executar uma vez o teste original intacto, com ambiente isolado e dependências existentes:
   PYTHONDONTWRITEBYTECODE=1 PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 python -m pytest -q -p no:cacheprovider tests/unit/test_health_unit.py
   Equivalente ao comando candidato python -m pytest -q tests/unit/test_health_unit.py, com cache/bytecode e carregamento automático de plugins desabilitados. Registrar comando efetivo, versões e ambiente; não habilitar plugins nem contornar falhas sem decisão própria.
4. Registrar stdout/stderr sanitizados, código de retorno, contagem e estado/diff antes e depois. Esperado: 3 casos aprovados, código 0, nenhum arquivo de produto alterado. Não transformar expectativa em resultado.
5. Publicar evidência e estado da tentativa exclusivamente nos três caminhos documentais autorizados, acrescentando seção ao parecer C01. Retornar somente TKC-PAR-0016 + SHA, ou referência + BLOQUEADA + motivo breve se não puder publicar. Medir esforço, intervenções, retrabalho e custo quando possível, ou NÃO MEDIDO.

## Limites e aceite
Sem Docker, VM, PostgreSQL, rede de teste, instalação, código/patch, alterações de dependências, CI, credenciais, configurações, permissões ou normas. Não executar piloto, não integrar C03 anterior, não homologar M3-02. Falha ou ausência de capacidade implica parada e registro do impedimento, não correção de ambiente por iniciativa própria. Sucesso demonstra capacidade apenas para esta sessão e ambiente, sujeito à conferência das evidências; não equivale a teste independente nem autorização do patch. Revisão posterior por AGT-002 mediante atribuição específica; eventual AUT do piloto separada. A publicação desta proposta por AGT-001 III foi autorizada em C02, não a execução por AGT-004.
