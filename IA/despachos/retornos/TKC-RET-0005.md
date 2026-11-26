# TKC-RET-0005 — Entrega da Fase A

**Origem:** AGT-001, publicação direta Git; **autorização:** HUMAN-001 `Fase A de TKC-AUT-0005 #TRUE`, origem `MEDIADO` no Git.
**Situação:** `PRONTA_PARA_REVISAO`, não `CONCLUIDA`.

## Entregas
- Backend FastAPI Python 3.12, `GET /health` com query PostgreSQL `SELECT 1`, retorno 200/503 sanitizado.
- Testes unitários com mocks e teste de integração opt-in para Fase B.
- Dockerfile backend, Compose restrito à API; reutiliza PostgreSQL existente `tkc-postgres16`, exige rede externa planejada `tkc-lab-net` e env local.
- Documentação de arquitetura, contrato API, infraestrutura, testes e operação; gitignore para segredos.

## Evidências
- Base `e0e74c1337536501042e7cd43e758d9e2c817f34`; reivindicação `d7a9900b50b88bfa79f3d28be66fb8e3e7552faf`; implementação `959745e5513e313e477ef9cdd734111af2b9768f`.
- Caminhos da Fase A publicados conforme `TKC-AUT-0005`. Testes unitários/integrados e Docker: `NÃO_EXECUTADO`; nenhuma comprovação de API rodando ou de resposta HTTP real.
- Fase B: `PENDENTE`, exige aprovação e revisão de versões; nenhuma porta aberta ou serviço alterado por AGT-001.

## Pendências e critérios
Revisar código por outra sessão; fixar componentes e realizar testes em ambiente autorizado; conectar backend à rede Docker do PostgreSQL sem recriar o banco; observar 200, 503 e recuperação; integrar teste e status no menu somente após autorização para editar `scripts/infra/teamkit-lab.sh`. M3-02 não concluído.

## C07 — Atualização Fase B

Orquestrador de laboratório backend-lab.sh e menu ampliado entregues; código original imutável em 959745e5513e313e477ef9cdd734111af2b9768f. Pendente diagnóstico, build e testes reais pela VM. Revisão independente e fixação de versões exigidas antes de produção.
