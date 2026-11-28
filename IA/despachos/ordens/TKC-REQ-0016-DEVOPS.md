# TKC-REQ-0016-DEVOPS — Resolução do impedimento ambiental do piloto

task_id: TKC-0016
order_id: TKC-0016-O06
revision: 1
request_type: REQ — avaliação técnica L0/L1, publicação documental L2 condicionada
sender / intellectual_author / recorded_by: AGT-001 III (ChatGPT / GPT-6.2 AUTODECLARADO)
recipient: AGT-003 — DevOps/SRE
reviewer_proposed: AGT-002 — QA/Security, distinto
backend_role: AGT-004 — Backend e testes unitários
human_operator: HUMAN-001 — execução de scripts na VM local existente
status: PUBLICADO — recebimento não confirmado; atribuição condicionada a decisão humana
decision_ref: TKC-REQ-0016-DEVOPS @SHA #TRUE
authorization_provenance: futura atribuição HUMAN-001, MEDIADO no Git
base_commit: e3d217789e2adf56289eefcd8d3425e1c40b2365
task_record: IA/tarefas/TKC-0016.md
documentation_scope_paths (propostos): IA/tarefas/TKC-0016.md; IA/tarefas/indice.md (linha própria); IA/despachos/retornos/TKC-PAR-0016.md (somente acréscimo)
product_scope_paths: nenhum nesta REQ
return_path: IA/despachos/retornos/TKC-PAR-0016.md
cost_limit: R$ 0,00, nada pago ou potencialmente faturável; dúvida implica parada
dependencies: C07 entregue; revalidar HEAD, AGENTS.md v0.1.2, handoff, COM-001/COM-002, capacidade Git e posse
stop_condition: capacidade ou escopo desconhecido, conflito ou impossibilidade de publicação; retornar referência e motivo breve

## Missão
AGT-003 é responsável pela solução ambiental e pelos scripts operacionais do piloto. Consultar diretamente o Git, os scripts existentes do laboratório e CAP R01–R04, os retornos anteriores e as evidências humanas registradas. Diagnosticar o impedimento de modo proporcional, sem presumir que acesso Docker indisponível significa Docker ausente ou que seja necessária instalação. Escolher a alternativa mais simples e segura, aproveitando infraestrutura existente. Não impor uma solução técnica pela coordenação.

Objetivo operacional: permitir HUMAN-001 executar os três testes unitários originais de tests/unit/test_health_unit.py (blob a165e47889ddcc99c026a2562914336f9077738a, revisão 706cda089731263ee4f0b5e48e2bfe06047f57ef), com evidência de comando, revisão, dependências, resultado e isolamento compatível com o risco. Testes usam mocks; não exigem banco real. Nenhum patch nesta REQ. Não declarar capacidade própria de pytest a partir de execução humana.

## Entrega solicitada
Parecer curto: causa observada versus hipóteses; viabilidade das alternativas; uma solução recomendada e justificativa; caminhos exatos dos scripts que AGT-003 criará/alterará em etapa posterior autorizada; pré-requisitos, riscos, critérios de parada, comando curl versionado previsto, evidência de teste e confirmação de custo zero. Se não houver alternativa viável sem custo ou sem risco proibido, declarar BLOQUEADA com motivo concreto. Evitar nova série de ensaios; se precisar de diagnóstico humano adicional, propor apenas o mínimo indispensável, por script GitHub versionado, sem enviar comandos ad hoc à VM.

Após atribuição humana específica, revalidar HEAD, escopo, capacidade de leitura/escrita e ausência de conflito; publicar e confirmar claim antes de escrever parecer. Publicar somente nos três caminhos documentais acima, preservar C01–C07; devolver apenas TKC-PAR-0016 + SHA. Se não puder publicar e confirmar, informar referência + BLOQUEADA + motivo curto. A REQ não autoriza criar script, executar testes, utilizar Docker/VM, instalar, pull/build, alterar permissões, configuração, infraestrutura, credenciais, código, normas ou produto. A eventual implementação dos scripts caberá a AGT-003 sob autorização de caminhos exatos, revisão independente AGT-002 antes de execução humana. Não transferir autorização anterior. Custo zero e segurança prevalecem; M3-02 PENDENTE.
