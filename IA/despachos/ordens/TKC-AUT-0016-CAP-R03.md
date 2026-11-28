# TKC-AUT-0016-CAP-R03 — Ensaio humano em VM local

task_id: TKC-0016
order_id: TKC-0016-O04
revision: 3
supersedes: R02 @52d29385598f866c0a1a3f26335234d09f57aace, não encaminhada; R01/C03 preservadas
status / authorization_state: PENDENTE — execução humana requer decisão específica
executor: HUMAN-001 — VM local existente
coordinator / intellectual_author / recorded_by: AGT-001 III (ChatGPT GPT-6.2 AUTODECLARADO)
reviewer_proposed: AGT-002 (revisão distinta, autorização própria)
backend_role: AGT-004 — desenvolvimento, não executor de testes desta ordem
base_commit: 11a75c5c4ace3d23f16b79bed223cd71e5f5744c
script: scripts/qa/tkc-0016-cap.sh @fd6b4d5cf702de73762ddd215ade765660be3107
script_blob: d40ac212b974b48643b9523d25f2e697f6075e94
test_revision: 706cda089731263ee4f0b5e48e2bfe06047f57ef
test_blob: a165e47889ddcc99c026a2562914336f9077738a
cost_limit: R$ 0,00; nada pago, nada potencialmente faturável; dúvida implica parada
risk: L2 — diagnóstico local em VM existente, sem alteração de produto
scope: download do script por HTTPS no GitHub, verificação, aquisição Git somente leitura da revisão fixa em diretório temporário local, ensaio isolado e envio de resumo
remote_write_scope: nenhum para HUMAN-001 nesta ordem; registro posterior pela coordenação depende de autorização explícita
decision_ref: TKC-AUT-0016-CAP-R03 @SHA #TRUE
provenance: decisão e resultado humanos MEDIADO; publicação do script VERIFICADA; execução não comprovada
dependencies: C05 entregue, nenhuma posse ativa; custo zero e ambiente local existente confirmado por HUMAN-001
stop_condition: dúvida de custo, falta de ferramenta, dependência, integridade ou isolamento, aquisição ou teste falho; não repetir nem corrigir por iniciativa própria

## Procedimento
HUMAN-001 executa somente na VM local existente, usando um comando de download via curl HTTPS vinculado ao commit do script. Usar arquivo temporário exclusivo; verificar que o download não está vazio, comparar o hash Git do script com o blob acima e conferir sintaxe bash -n antes de executar. Não usar curl | bash sem validação. O argumento --custo-zero-confirmado é declaração humana de que a rede e recursos existentes não têm possibilidade de cobrança; não é mecanismo de verificação de faturamento. Se houver qualquer dúvida, não iniciar sequer o download.

O script confirma ferramentas existentes, testa disponibilidade de namespace de rede sem sudo, verifica versões de Python, pytest, FastAPI, httpx e psycopg em ambiente mínimo, obtém por leitura pública a revisão fixa do repositório em diretório temporário, confirma SHA e blob e estado limpo; rejeita configuração pytest inesperada. Executa somente o teste original, em namespace de rede isolado, sem variáveis de ambiente reais, com HOME/TMPDIR temporários, cache/bytecode e autoload de plugins desabilitados. Rede permitida apenas para aquisição pública GitHub; sem credenciais. Nenhum isolamento de filesystem completo é alegado. O script não instala dependências, não altera configuração de rede do host, não cria VM, não usa Docker ou PostgreSQL, não inicia serviços, não faz push e não modifica checkout existente. Diretório temporário exclusivo removido ao terminar. A criação de um repositório Git temporário local não cria recurso remoto ou faturável.

Comando de teste: python -m pytest -q -p no:cacheprovider --color=no --tb=no tests/unit/test_health_unit.py. Resultado esperado: 3 passed, código 0, revisão e estado limpo antes/depois. O script imprime versões, SHA, blob, isolamento, código de retorno e contagens reconhecidas, sem stdout/stderr brutos para evitar exposição de segredos. Se faltar pré-requisito, registrar motivo de bloqueio. Resultado esperado não é evidência observada.

## Retorno
HUMAN-001 envia apenas resumo exibido pelo script (CAP=ENTREGUE ou CAP=BLOQUEADA e linhas de evidência). AGT-001 avalia e, com autorização documental própria, acrescenta evidência MEDIADO ao parecer, tarefa e linha do índice, preservando histórico; não atribuir execução à IA nem capacidade pytest própria de AGT-004. AGT-002 revisa fontes e evidências quando atribuído. Sucesso permite avaliar autorização separada do patch; não conclui TKC-0016 ou M3-02. A autoria do script é da coordenação, não revisão independente. Não houve teste de execução pela IA; bash -n na VM é pré-requisito, não teste funcional. Métricas NÃO MEDIDO nesta preparação.

## Limites superiores
R$ 0,00 inclusive possibilidade de cobrança futura. Nenhuma instalação, recurso remoto, serviço pago, mudança de permissões, credenciais, configuração, infraestrutura, patch, reintegração do incidente ou execução pela IA. A ordem R03 não autoriza mudanças normativas. Não usar resultado de execução humana como evidência de capacidade autônoma de agente. Se bloqueado, avaliar evidência e encaminhar decisão objetiva, sem repetir indefinidamente.
