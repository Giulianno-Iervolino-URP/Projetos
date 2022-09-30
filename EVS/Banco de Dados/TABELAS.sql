/* MER: */
--CREATE USER EVS IDENTIFIED BY 123456;
---DROP
DECLARE
    V_CTR VARCHAR(300);
BEGIN
    FOR C IN (SELECT 'DROP TABLE ' || A.OWNER || '.' || A.TABLE_NAME AS CMD
                FROM ALL_ALL_TABLES A
               WHERE A.OWNER = 'EVS') LOOP
        BEGIN
            EXECUTE IMMEDIATE (C.CMD);
        EXCEPTION
            WHEN OTHERS THEN
                CONTINUE;
        END;
    END LOOP;
END;
---
/ 
---
CREATE TABLE EVS.USUARIO(NM_USUARIO VARCHAR(30)
                          ,DS_HASH_SENHA VARCHAR(1000)
                          ,FL_ATIVO CHAR(1)
                          ,DS_EMAIL VARCHAR(150)
                          ,DS_IMG_PERFIL VARCHAR(1000)
                          ,TP_USUARIO VARCHAR(2)
                          ,DS_NM_USUARIO VARCHAR(150)
                          ,NM_USR_CADASTRO VARCHAR(30)
                          ,DT_CADASTRO DATE
                          ,NM_USR_ALTERACAO VARCHAR(30)
                          ,DT_ALTERACAO DATE
                          ,CONSTRAINT USUARIO_PK PRIMARY KEY(NM_USUARIO));
CREATE INDEX EVS.USUARIO_TP_USUARIO_IDX ON EVS.USUARIO(TP_USUARIO);
--
CREATE TABLE EVS.INDICADOR(CD_INDICADOR NUMBER
                          ,NM_INDICADOR VARCHAR(150)
                          ,FL_ATIVO CHAR(1)
                          ,NR_PESO NUMBER
                          ,DS_OBJETIVO VARCHAR(1000)
                          ,NM_USR_CADASTRO VARCHAR(30)
                          ,DT_CADASTRO DATE
                          ,NM_USR_ALTERACAO VARCHAR(30)
                          ,DT_ALTERACAO DATE
                          ,CD_DIMENSAO NUMBER
                          ,CONSTRAINT INDICADOR_PK PRIMARY
                           KEY(CD_INDICADOR)
                          ,CONSTRAINT IND_DIM_FK FOREIGN KEY(CD_DIMENSAO)
                           REFERENCES EVS.INDICADOR(CD_INDICADOR));
CREATE INDEX EVS.INDICADOR_CD_DIMENSAO_IDX ON EVS.INDICADOR(CD_DIMENSAO);
---
CREATE TABLE EVS.ESPECIALIDADE(CD_ESPECIALIDADE NUMBER
                              ,NM_ESPECIALIDADE VARCHAR(150)
                              ,FL_ATIVO CHAR(1)
                              ,CD_INTEGRACAO NUMBER
                              ,NM_USR_CADASTRO VARCHAR(30)
                              ,DT_CADASTRO DATE
                              ,NM_USR_ALTERACAO VARCHAR(30)
                              ,DT_ALTERACAO DATE
                              ,CONSTRAINT ESPECIALIDADE_PK PRIMARY
                               KEY(CD_ESPECIALIDADE));
CREATE TABLE EVS.INDICADOR_ESPECIALIDADE(NR_SEQ_IND_ESP NUMBER
                                        ,NM_USUARIO_CADASTRO VARCHAR(30)
                                        ,DT_CADASTRO DATE
                                        ,CD_ESPECIALIDADE NUMBER
                                        ,CD_INDICADOR NUMBER
                                        ,CONSTRAINT IND_ESP_PK PRIMARY
                                         KEY(NR_SEQ_IND_ESP)
                                        ,CONSTRAINT IND_ESP_ESP_FK FOREIGN
                                         KEY(CD_ESPECIALIDADE) REFERENCES
                                         EVS.ESPECIALIDADE(CD_ESPECIALIDADE)
                                        ,CONSTRAINT IND_ESP_IND_FK FOREIGN
                                         KEY(CD_INDICADOR) REFERENCES
                                         EVS.INDICADOR(CD_INDICADOR));
--
CREATE INDEX EVS.INDI_ESP_CD_ESP_IDX ON EVS.INDICADOR_ESPECIALIDADE(CD_ESPECIALIDADE);
CREATE INDEX EVS.INDI_ESP_CD_IND ON EVS.INDICADOR_ESPECIALIDADE(CD_INDICADOR);
--
CREATE TABLE EVS.PROCEDIMENTO(CD_PROCEDIMENTO NUMBER
                             ,CD_ORIGEM NUMBER
                             ,FL_ATIVO CHAR(1)
                             ,NM_PROCEDIMENTO VARCHAR(200)
                             ,NM_USR_CADASTRO VARCHAR(30)
                             ,DT_CADASTRO DATE
                             ,NM_USR_ALTERACAO VARCHAR(30)
                             ,DT_ALTERACAO DATE
                             ,CD_INTEGRACAO NUMBER
                             ,CONSTRAINT PROCEDIMENTO_PK PRIMARY
                              KEY(CD_PROCEDIMENTO));
CREATE TABLE EVS.AVALIADO(CD_AVALIADO NUMBER
                         ,NM_USUARIO VARCHAR(30) UNIQUE
                         ,FL_ATIVO CHAR(1)
                         ,CD_INTEGRACAO NUMBER
                         ,NR_CRM VARCHAR(20)
                         ,NM_USR_CADASTRO VARCHAR(30)
                         ,DT_CADASTRO DATE
                         ,NM_USR_ALTERACAO VARCHAR(30)
                         ,DT_ALTERACAO DATE
                         ,CD_ESPECIALIDADE NUMBER
                         ,CONSTRAINT AVALIADO_PK PRIMARY KEY(CD_AVALIADO)
                         ,CONSTRAINT AVAL_USU_FK FOREIGN KEY(NM_USUARIO)
                          REFERENCES EVS.USUARIO(NM_USUARIO)
                         ,CONSTRAINT AVAL_ESP_FK FOREIGN
                          KEY(CD_ESPECIALIDADE) REFERENCES
                          EVS.ESPECIALIDADE(CD_ESPECIALIDADE));
--
CREATE INDEX EVS.AVALIADO_NR_CRM_IDX ON EVS.AVALIADO(NR_CRM);
--
CREATE TABLE EVS.DOMINIO(CD_DOMINIO NUMBER
                        ,NM_DOMINIO VARCHAR(150)
                        ,FL_ATIVO CHAR(1)
                        ,NR_PESO NUMBER
                        ,NM_USR_CADASTRO VARCHAR(30)
                        ,DT_CADASTRO DATE
                        ,NM_USR_ALTERACAO VARCHAR(30)
                        ,DT_ALTERACAO DATE
                        ,CONSTRAINT DOMINIO_PK PRIMARY KEY(CD_DOMINIO));
CREATE TABLE EVS.PERIODO(NR_SEQ_PERIODO NUMBER
                        ,DT_MES_ANO_REF DATE
                        ,FL_ATIVO CHAR(1)
                        ,DS_PERIODO VARCHAR(300)
                        ,DT_INICIAL DATE
                        ,DT_FINAL DATE
                        ,DS_OBSERVACAO VARCHAR(4000)
                        ,NM_USR_CADASTRO VARCHAR(30)
                        ,DT_CADASTRO DATE
                        ,NM_USR_ALTERACAO VARCHAR(30)
                        ,DT_ALTERACAO DATE
                        ,CONSTRAINT NR_SEQ_PERIODO_PK PRIMARY
                         KEY(NR_SEQ_PERIODO));
--
CREATE INDEX EVS.PERIODO_DT_MES_ANO_REF_IDX ON EVS.PERIODO(DT_MES_ANO_REF);
--
CREATE TABLE EVS.DIMENSAO(CD_DIMENSAO NUMBER
                         ,NM_DIMENSAO VARCHAR(150)
                         ,FL_ATIVO CHAR(1)
                         ,NR_PESO NUMBER
                         ,NM_USR_CADASTRO VARCHAR(30)
                         ,DT_CADASTRO DATE
                         ,NM_USR_ALTERACAO VARCHAR(30)
                         ,DT_ALTERACAO DATE
                         ,CD_DOMINIO NUMBER
                         ,CONSTRAINT DIMENSAO_PK PRIMARY KEY(CD_DIMENSAO)
                         ,CONSTRAINT DIM_DOM_FK FOREIGN KEY(CD_DOMINIO)
                          REFERENCES EVS.DOMINIO(CD_DOMINIO));
CREATE TABLE EVS.IND_PROC(NR_SEQ NUMBER
                         ,CD_INDICADOR NUMBER
                         ,CD_PROCEDIMENTO NUMBER
                         ,CONSTRAINT IND_PROC_PK PRIMARY KEY(NR_SEQ)
                         ,CONSTRAINT IND_PROC_IND FOREIGN
                          KEY(CD_INDICADOR) REFERENCES
                          EVS.INDICADOR(CD_INDICADOR)
                         ,CONSTRAINT IND_PROC_PROC_FK FOREIGN
                          KEY(CD_PROCEDIMENTO) REFERENCES
                          EVS.PROCEDIMENTO(CD_PROCEDIMENTO));
CREATE TABLE EVS.AVAL_MES(NR_SEQ_AVAL_MES NUMBER
                         ,DT_MES_ANO_REF DATE
                         ,FL_ATIVO CHAR(1)
                         ,QT_PONTOS NUMBER
                         ,VL_BONIFICACAO NUMBER
                         ,DT_CALCULO DATE
                         ,NM_USUARIO VARCHAR(30)
                         ,CD_INDICADOR NUMBER
                         ,CD_AVALIADO NUMBER
                         ,NR_SEQ_PERIODO NUMBER
                         ,CONSTRAINT AVAL_MES_PK PRIMARY
                          KEY(NR_SEQ_AVAL_MES)
                         ,CONSTRAINT AVAL_MES_IND_FK FOREIGN
                          KEY(CD_INDICADOR) REFERENCES
                          EVS.INDICADOR(CD_INDICADOR)
                         ,CONSTRAINT AVAL_MES_AVAL_FK FOREIGN
                          KEY(CD_AVALIADO) REFERENCES
                          EVS.AVALIADO(CD_AVALIADO)
                         ,CONSTRAINT AVAL_MES_PERI_FK FOREIGN
                          KEY(NR_SEQ_PERIODO) REFERENCES
                          EVS.PERIODO(NR_SEQ_PERIODO));
--
CREATE INDEX EVS.AVAL_MES_DT_MES_ANO_REF_IDX ON EVS.AVAL_MES(DT_MES_ANO_REF);
CREATE INDEX EVS.AVAL_MES_CD_INDICADOR_IDX ON EVS.AVAL_MES(CD_INDICADOR);
CREATE INDEX EVS.AVAL_MES_CD_AVALIADO_IDX ON EVS.AVAL_MES(CD_AVALIADO);
CREATE INDEX EVS.AVAL_MES_NR_SEQ_PERIODO_IDX ON EVS.AVAL_MES(NR_SEQ_PERIODO);
--
CREATE TABLE EVS.AVAL_ANO(NR_SEQ_AVAL_ANO NUMBER
                         ,DT_MES_ANO_REF DATE
                         ,FL_ATIVO CHAR(1)
                         ,QT_PONTOS NUMBER
                         ,VL_BONIFICACAO NUMBER
                         ,DT_CALCULO DATE
                         ,NM_USUARIO VARCHAR(30)
                         ,CD_INDICADOR NUMBER
                         ,CD_AVALIADO NUMBER
                         ,NR_SEQ_PERIODO NUMBER
                         ,CONSTRAINT AVAL_ANO_PK PRIMARY
                          KEY(NR_SEQ_AVAL_ANO)
                         ,CONSTRAINT AVAL_ANO_IND_FK FOREIGN
                          KEY(CD_INDICADOR) REFERENCES
                          EVS.INDICADOR(CD_INDICADOR)
                         ,CONSTRAINT AVAL_ANO_AVAL_FK FOREIGN
                          KEY(CD_AVALIADO) REFERENCES
                          EVS.AVALIADO(CD_AVALIADO)
                         ,CONSTRAINT AVAL_ANO_PERI_FK FOREIGN
                          KEY(NR_SEQ_PERIODO) REFERENCES
                          EVS.PERIODO(NR_SEQ_PERIODO));
--
CREATE INDEX EVS.AVAL_ANO_DT_MES_ANO_REF_IDX ON EVS.AVAL_ANO(DT_MES_ANO_REF);
CREATE INDEX EVS.AVAL_ANO_CD_INDICADOR_IDX ON EVS.AVAL_ANO(CD_INDICADOR);
CREATE INDEX EVS.AVAL_ANO_CD_AVALIADO_IDX ON EVS.AVAL_ANO(CD_AVALIADO);
CREATE INDEX EVS.AVAL_ANO_NR_SEQ_PERIODO_IDX ON EVS.AVAL_ANO(NR_SEQ_PERIODO);
--
CREATE TABLE EVS.ESP_MES(NR_SEQ_ESP_MES NUMBER
                        ,DT_MES_REF DATE
                        ,FL_ATIVO CHAR(1)
                        ,QT_PONTOS NUMBER
                        ,VL_BONIFICACAO NUMBER
                        ,DT_CALCULO DATE
                        ,NM_USUARIO VARCHAR(30)
                        ,CD_INDICADOR NUMBER
                        ,CD_ESPECIALIDADE NUMBER
                        ,NR_SEQ_PERIODO NUMBER
                        ,CONSTRAINT ESP_MES_PK PRIMARY KEY(NR_SEQ_ESP_MES)
                        ,CONSTRAINT ESP_MES_INDI_FK FOREIGN
                         KEY(CD_INDICADOR) REFERENCES
                         EVS.INDICADOR(CD_INDICADOR)
                        ,CONSTRAINT ESP_MES_ESP_FK FOREIGN
                         KEY(CD_ESPECIALIDADE) REFERENCES
                         EVS.ESPECIALIDADE(CD_ESPECIALIDADE)
                        ,CONSTRAINT ESP_MEES_PERI_FK FOREIGN
                         KEY(NR_SEQ_PERIODO) REFERENCES
                         EVS.PERIODO(NR_SEQ_PERIODO));
--
CREATE INDEX EVS.ESP_MES_DT_MES_REF_IDX ON EVS.ESP_MES(DT_MES_REF);
CREATE INDEX EVS.ESP_MES_CD_INDICADOR_IDX ON EVS.ESP_MES(CD_INDICADOR);
CREATE INDEX EVS.ESP_MES_CD_ESPECIALIDADE_IDX ON EVS.ESP_MES(CD_ESPECIALIDADE);
CREATE INDEX EVS.ESP_MES_NR_SEQ_PERIODO_IDX ON EVS.ESP_MES(NR_SEQ_PERIODO);
--
CREATE TABLE EVS.ESP_ANO(NR_SEQ_ESP_ANO NUMBER
                        ,DT_ANO_REF DATE
                        ,FL_ATIVO CHAR(1)
                        ,QT_PONTOS NUMBER
                        ,VL_BONIFICACAO NUMBER
                        ,DT_CALCULO DATE
                        ,NM_USUARIO VARCHAR(30)
                        ,CD_INDICADOR NUMBER
                        ,CD_ESPECIALIDADE NUMBER
                        ,NR_SEQ_PERIODO NUMBER
                        ,CONSTRAINT ESP_ANO_PK PRIMARY KEY(NR_SEQ_ESP_ANO)
                        ,CONSTRAINT ESP_ANO_IND_FK FOREIGN
                         KEY(CD_INDICADOR) REFERENCES
                         EVS.INDICADOR(CD_INDICADOR)
                        ,CONSTRAINT ESP_ANO_ESP_FK FOREIGN
                         KEY(CD_ESPECIALIDADE) REFERENCES
                         EVS.ESPECIALIDADE(CD_ESPECIALIDADE)
                        ,CONSTRAINT ESP_ANO_PERI_FK FOREIGN
                         KEY(NR_SEQ_PERIODO) REFERENCES
                         EVS.PERIODO(NR_SEQ_PERIODO));
--
CREATE INDEX EVS.ESP_ANO_DT_ANO_REF_IDX ON EVS.ESP_ANO(DT_ANO_REF);
CREATE INDEX EVS.ESP_ANO_CD_INDICADOR_IDX ON EVS.ESP_ANO(CD_INDICADOR);
CREATE INDEX EVS.ESP_ANO_CD_ESPECIALIDADE_IDX ON EVS.ESP_ANO(CD_ESPECIALIDADE);
CREATE INDEX EVS.ESP_ANO_NR_SEQ_PERIODO_IDX ON EVS.ESP_ANO(NR_SEQ_PERIODO);
--
CREATE TABLE EVS.FAIXA(NR_SEQ_FAIXA NUMBER
                      ,VL_FAIXA_INI NUMBER
                      ,FL_ATIVO CHAR(1)
                      ,VL_FAIXA_FIM NUMBER
                      ,VL_BONIFICACAO NUMBER
                      ,NM_USR_CADASTRO VARCHAR(30)
                      ,DT_CADASTRO DATE
                      ,NM_USR_ALTERACAO VARCHAR(30)
                      ,DT_ALTERACAO DATE
                      ,NR_SEQ_PERIODO NUMBER
                      ,CONSTRAINT FAIXA_PK PRIMARY KEY(NR_SEQ_FAIXA)
                      ,CONSTRAINT FAIXA_PERIODO_FK FOREIGN
                       KEY(NR_SEQ_PERIODO) REFERENCES
                       EVS.PERIODO(NR_SEQ_PERIODO));
CREATE TABLE EVS.RESTRICAO_AVALIADO(CD_RESTRICAO NUMBER
                                   ,DS_RESTRICAO VARCHAR(300)
                                   ,FL_ATIVO CHAR(1)
                                   ,DS_OBSERVACAO VARCHAR(4000)
                                   ,NM_USR_CADASTRO VARCHAR(30)
                                   ,DT_CADASTRO DATE
                                   ,NM_USR_ALTERACAO VARCHAR(30)
                                   ,DT_ALTERACAO DATE
                                   ,CONSTRAINT EVS_RESTR_AVAL_PK PRIMARY
                                    KEY(CD_RESTRICAO));
CREATE TABLE EVS.AVAL_RESTR_PERIODO(NR_SEQ_REST_AVAL NUMBER
                                   ,FL_ATIVO CHAR(1)
                                   ,DT_INI_VIG DATE
                                   ,DT_FIM_VIG DATE
                                   ,NM_USR_CADASTRO VARCHAR(30)
                                   ,DT_CADASTRO DATE
                                   ,NM_USR_ALTERACAO VARCHAR(30)
                                   ,DT_ALTERACAO DATE
                                   ,CD_RESTRICAO NUMBER
                                   ,CD_PERIODO NUMBER
                                   ,CD_AVALIADO NUMBER
                                   ,CONSTRAINT EVS_AVAL_RESTR_PER_PK
                                    PRIMARY KEY(NR_SEQ_REST_AVAL)
                                   ,CONSTRAINT RESTR_AVAL_PER_FK FOREIGN
                                    KEY(CD_RESTRICAO) REFERENCES
                                    EVS.RESTRICAO_AVALIADO(CD_RESTRICAO)
                                   ,CONSTRAINT PERI_RESTR_AVAL_FK FOREIGN
                                    KEY(CD_PERIODO) REFERENCES
                                    EVS.PERIODO(NR_SEQ_PERIODO)
                                   ,CONSTRAINT AVAL_RESTR_AVAL_FK FOREIGN
                                    KEY(CD_AVALIADO) REFERENCES
                                    EVS.AVALIADO(CD_AVALIADO));
CREATE TABLE EVS.LOG_PCK_EVS(SEQ_LOG NUMBER
                            ,DT_LOG        DATE DEFAULT SYSDATE
                            ,NM_OBJETO VARCHAR(300)
                            ,FL_ERRO       CHAR(1) DEFAULT 'N'
                            ,DS_ERRM VARCHAR(300)
                            ,DS_LOG VARCHAR(4000)
                            ,DS_JSON CLOB
                            ,DS_PARAMETROS VARCHAR(4000)
                            ,CONSTRAINT LOG_PCK_EVS_PK PRIMARY
                             KEY(SEQ_LOG));
