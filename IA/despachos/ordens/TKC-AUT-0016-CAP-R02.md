# TKC-AUT-0016-CAP-R02 — Ensaio de capacidade com aquisição controlada de cópia

task_id: TKC-0016
order_id: TKC-0016-O03
short_ref: TKC-AUT-0016-CAP-R02
revision: 2 (SHA completo resolvido após publicação)
supersedes: TKC-AUT-0016-CAP revisão 1 @67f1e375943e3c0cf12d0def9b9d7fa9f9591f2c; C03 encerrada, autorização consumida
request_type: AUT — capacidade, não patch
executor / recipient: AGT-004 — Backend, sessão C01/C03; revalidar atribuição e capacidade
reviewer: AGT-002 — QA / Segurança / Auditoria, distinto; autorização de revisão separada
sender / intellectual_author / recorded_by: AGT-001 III (ChatGPT / GPT-6.2 AUTODECLARADO)
status / authorization_state: PENDENTE — publicação não é autorização nem recebimento
decision_ref: TKC-AUT-0016-CAP-R02 @SHA #TRUE, somente após decisão humana explícita
authorization_provenance: futura decisão HUMAN-001; MEDIADO no Git
repository / branch: edinhogrubert/TeamKitCollection / main
base_commit: 152afb1ffdcd8934b771698135572bff15619425
test_revision: 706cda089731263ee4f0b5e48e2bfe06047f57ef (mesma revisão da R01)
task_record: IA/tarefas/TKC-0016.md
product_scope_paths: nenhum para escrita no produto, local ou remota
documentation_scope_paths (propostos): IA/tarefas/TKC-0016.md; IA/tarefas/indice.md (linha própria); IA/despachos/retornos/TKC-PAR-0016.md (somente acréscimo, preservar C01/C03)
return_path: IA/despachos/retornos/TKC-PAR-0016.md
log_path: eventos na tarefa
risk / cost_limit: L2 controlada, aquisição local e ensaio unitário; R$ 0,00 adicional
capability_evidence: leitura/escrita Git C01/C03 confirmadas; checkout e execução pytest DESCONHECIDOS
dependencies: C04 preparação entregue; nenhuma posse ativa ou conflito; COM-001 v0.3.0
stop_condition: BLOQUEADA se qualquer pré-requisito obrigatório falhar; sem contornar restrições

## Mudança única em relação à R01
Caso HUMAN-001 aprove esta revisão, autorizar obtenção de uma cópia isolada do próprio repositório GitHub na revisão test_revision, por leitura autenticada já disponível ou acesso público, conforme permissões efetivas. É permitida rede exclusivamente para leitura do repositório durante a aquisição e para comunicação Git documental autorizada; não durante os testes. Usar clone/fetch somente leitura ou arquivo oficial de revisão imutável com integridade verificável, sem criar branch remota, sem fornecer, exportar ou registrar credenciais, sem modificar permissões. Diretório local novo, exclusivo e descartável da sessão, sem sobrescrever arquivos existentes. Registrar caminho, origem, revisão e método de verificação. Verificar checkout limpo e SHA completo; se usar arquivo oficial em vez de Git, verificar correspondência dos arquivos à árvore da revisão por evidência Git confiável. Não aceitar reconstrução parcial ou integridade desconhecida. Se não houver meio autorizado e tecnicamente disponível de aquisição, parar. Nenhuma instalação ou aquisição de dependências autorizada.

## Procedimento e aceite
1. Revalidar HEAD, ordem, autorização, escopo, regras e ausência de conflito; publicar e confirmar claim remoto de nova tentativa antes de adquirir cópia ou iniciar ensaio. Não herdar autorização C03.
2. Obter ou localizar cópia conforme acima; conferir revisão exata, estado limpo e blob a165e47889ddcc99c026a2562914336f9077738a de tests/unit/test_health_unit.py. Conferir disponibilidade de Python, pytest, FastAPI, httpx e psycopg e configuração pytest, conftest/imports/efeitos colaterais, sem instalar. Confirmar ambiente de teste sem credenciais reais e sem rede externa por isolamento já disponível; não alterar configuração de rede, permissões ou infraestrutura. Se faltar pré-requisito, parar e registrar motivo concreto.
3. Executar uma vez na raiz da cópia intacta:
   PYTHONDONTWRITEBYTECODE=1 PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 python -m pytest -q -p no:cacheprovider tests/unit/test_health_unit.py
4. Registrar versões, ambiente, comando efetivo, stdout/stderr sanitizados, código de retorno, casos observados e estado/diff antes/depois. Esperado 3 passed, saída 0, zero alterações de produto. Se falhar, registrar sem corrigir ou repetir por iniciativa própria. Não confundir expectativa com evidência.
5. Encerrar posse e publicar evidências nos três caminhos documentais propostos somente após autorização; preservar C01/C03. Retornar TKC-PAR-0016 + SHA ou referência + BLOQUEADA + motivo breve caso não possa publicar. Métricas quando medidas, ou NÃO MEDIDO.

## Limites
Sem patch, Docker, PostgreSQL, VM, instalação de dependências, rede durante testes, credenciais reais, CI, configurações, permissões, normas ou custo adicional. Não reutilizar o incidente TKC-0004-C03. Cópia local e temporários necessários não constituem autorização de alteração de produto. Sucesso comprova capacidade para a sessão/ambiente, não autoriza piloto nem homologa M3-02. Caso bloqueado, coordenação avaliará outra sessão executora apta com decisão própria, mantendo revisão independente. R01 permanece no histórico; esta proposta não autoriza execução antes da decisão humana.
