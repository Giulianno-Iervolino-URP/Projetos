CREATE OR REPLACE PACKAGE EVS.PCK_EVS IS

    /***********************************************************************************************************************************************************************
    * Autor: Giulianno Ferrari Iervolino
    * Sistema: EVS
    * Objetivo: ENCAPSULAR OBJETOS UTILIZADOS PELO EVS
    *
    * Altera??es :
    * |---------------------------------------------------------------------------------------------------------------------------------------------------------------------
    * | DATA         | RESPONSAVEL         | TICKET/CARD  | ALTERACAO
    * |--------------+------------------+----------------+-----------------------------------------------------------------------------------------------------------------
    * | 30/09/2022   | Giulianno Iervolino |   14738      | CRIA??O DO OBJETO
    * |--------------+------------------+-----------------+-----------------------------------------------------------------------------------------------------------------     *
    ************************************************************************************************************************************************************************/
    --------
    PROCEDURE PR_RETONA_CADASTRO_JSON_API(IN_JSON IN CLOB, OUT_JSON OUT CLOB);

    --------
    --------
    PROCEDURE PR_CADASTRA_USUARIO(IN_NM_USUARIO      IN VARCHAR
                                 ,IN_DS_HASH_SENHA   IN VARCHAR
                                 ,IN_DS_EMAIL        IN VARCHAR
                                 ,IN_TP_USUARIO      IN CHAR
                                 ,IN_DS_NM_USUARIO   IN VARCHAR
                                 ,IN_NM_USR_CADASTRO IN VARCHAR);

    --------                                 
    PROCEDURE PR_CADASTRA_ESPECIALIDADE(IN_NM_ESPECIALIDADE IN VARCHAR
                                       ,IN_CD_INTEGRACAO    IN NUMBER DEFAULT NULL
                                       ,IN_CD_ESPECIALIDADE IN NUMBER
                                       ,IN_NM_USR_CADASTRO  IN VARCHAR);

    -------                                    
    PROCEDURE PR_CADASTRA_PROCEDIMENTO(IN_CD_PROCEDIMENTO IN NUMBER DEFAULT NULL
                                      ,IN_CD_ORIGEM       IN NUMBER
                                      ,IN_NM_PROCEDIMENTO IN VARCHAR
                                      ,IN_CD_INTEGRACAO   IN NUMBER DEFAULT NULL
                                      ,IN_NM_USR_CADASTRO IN VARCHAR);

    --------                       
    PROCEDURE PR_CADASTRA_PERIODO(IN_DT_MES_ANO_REF  IN DATE
                                 ,IN_DT_INICIAL      IN DATE
                                 ,IN_DT_FINAL        IN DATE
                                 ,IN_DS_OBSERVACAO   IN VARCHAR DEFAULT NULL
                                 ,IN_NM_USR_CADASTRO IN VARCHAR);

    --------                       
    PROCEDURE PR_CADASTRA_FAIXA(IN_VL_FAIXA_INI    IN DATE
                               ,IN_VL_FAIXA_FIM    IN NUMBER
                               ,IN_VL_BONIFICACAO  IN NUMBER
                               ,IN_NM_USR_CADASTRO IN VARCHAR);

    --------
    PROCEDURE PR_CADASTRA_AVALIADO(IN_NM_USUARIO       IN VARCHAR
                                  ,IN_CD_INTEGRACAO    IN NUMBER DEFAULT NULL
                                  ,IN_NR_CRM           IN VARCHAR
                                  ,IN_CD_ESPECIALIDADE IN NUMBER
                                  ,IN_NM_USR_CADASTRO  IN VARCHAR);

    --------       
    PROCEDURE PR_CADASTRA_DOMINIO(IN_NM_DOMINIO      IN VARCHAR
                                 ,IN_NR_PESO         IN NUMBER DEFAULT NULL
                                 ,IN_NM_USR_CADASTRO IN VARCHAR);

    --------  
    PROCEDURE PR_CADASTRA_DIMENSAO(IN_NM_DIMENSAO     IN VARCHAR
                                  ,IN_NR_PESO         IN NUMBER DEFAULT NULL
                                  ,IN_NM_USR_CADASTRO IN VARCHAR);

    --------  
    PROCEDURE PR_CADASTRA_INDICADOR(IN_NM_INDICADOR    IN VARCHAR
                                   ,IN_NR_PESO         IN NUMBER DEFAULT NULL
                                   ,IN_DS_OBJETIVO     IN VARCHAR
                                   ,IN_NM_USR_CADASTRO IN VARCHAR);

    --------  
    PROCEDURE PR_CADASTRA_RESTRICAO(IN_DS_RESTRICAO    IN VARCHAR
                                   ,IN_DS_OBSERVACAO   IN NUMBER DEFAULT NULL
                                   ,IN_NM_USR_CADASTRO IN VARCHAR);

    --------  
    PROCEDURE PR_CALCULA_EVS_AVAL_MES(IN_NR_SEQ_PERIODO IN NUMBER);

    --------              
    PROCEDURE PR_CALCULA_EVS_AVAL_ANO(IN_NR_SEQ_PERIODO IN NUMBER);

    --------              
    PROCEDURE PR_CALCULA_EVS_ESP_MES(IN_NR_SEQ_PERIODO IN NUMBER);

    --------              
    PROCEDURE PR_CALCULA_EVS_ESP_ANO(IN_NR_SEQ_PERIODO IN NUMBER);

    --------              
    ---GRAVAR LOGS --DEIXAR ESTA NO FIM DA PCK
    PROCEDURE GRAVA_LOG(IN_NM_OBJ        IN VARCHAR
                       ,IN_FL_ERRO       IN CHAR DEFAULT 'N'
                       ,IN_DS_ERRM       IN VARCHAR DEFAULT NULL
                       ,IN_DS_LOG        IN VARCHAR
                       ,IN_JSON          IN CLOB
                       ,IN_DS_PARAMETROS IN VARCHAR DEFAULT 'SEM PARAMETROS'
                       ,OUT_SEQ_LOG      OUT NUMBER);

--
END PCK_EVS;
/
CREATE OR REPLACE PACKAGE BODY EVS.PCK_EVS IS

    /***********************************************************************************************************************************************************************
    * Autor: Giulianno Ferrari Iervolino
    * Sistema: EVS
    * Objetivo: ENCAPSULAR OBJETOS UTILIZADOS PELO EVS
    *
    * Altera??es :
    * |---------------------------------------------------------------------------------------------------------------------------------------------------------------------
    * | DATA         | RESPONSAVEL         | TICKET/CARD  | ALTERACAO
    * |--------------+------------------+----------------+-----------------------------------------------------------------------------------------------------------------
    * | 30/09/2022   | Giulianno Iervolino |   14738      | CRIA??O DO OBJETO
    * |--------------+------------------+-----------------+-----------------------------------------------------------------------------------------------------------------     *
    ************************************************************************************************************************************************************************/
    --PROCEDURES CHAMADAS POR APIs
    PV_INSTANCE VARCHAR2(40);

    PV_NM_PCK VARCHAR(80) := 'EVS.PCK_EVS';

    ---
    ---EXCEPTIONS 
    /*    NO_KEY_FOUND EXCEPTION;
    PRAGMA EXCEPTION_INIT(NO_KEY_FOUND, -20020);
    --
    NO_RESPONSE_FOUND EXCEPTION;
    PRAGMA EXCEPTION_INIT(NO_RESPONSE_FOUND, -20021);*/
    ---
    PROCEDURE PR_RECEBE_JSON_API(IN_JSON IN CLOB) AS
    BEGIN
        NULL;
    END PR_RECEBE_JSON_API;

    ---
    PROCEDURE PR_CADASTRA_USUARIO(IN_NM_USUARIO      IN VARCHAR
                                 ,IN_DS_HASH_SENHA   IN VARCHAR
                                 ,IN_DS_EMAIL        IN VARCHAR
                                 ,IN_TP_USUARIO      IN CHAR
                                 ,IN_DS_NM_USUARIO   IN VARCHAR
                                 ,IN_NM_USR_CADASTRO IN VARCHAR) AS
    BEGIN
        INSERT INTO EVS.USUARIO
            (NM_USUARIO
            ,DS_HASH_SENHA
            ,FL_ATIVO
            ,DS_EMAIL
            ,TP_USUARIO
            ,DS_NM_USUARIO
            ,NM_USR_CADASTRO
            ,DT_CADASTRO
            ,NM_USR_ALTERACAO
            ,DT_ALTERACAO)
        VALUES
            (IN_NM_USUARIO
            ,IN_DS_HASH_SENHA
            ,'A'
            ,IN_DS_EMAIL
            ,IN_TP_USUARIO
            ,IN_DS_NM_USUARIO
            ,IN_NM_USR_CADASTRO
            ,SYSDATE
            ,IN_NM_USR_CADASTRO
            ,SYSDATE);
    END PR_CADASTRA_USUARIO;

    ----
    --------                                 
    PROCEDURE PR_CADASTRA_ESPECIALIDADE(IN_NM_ESPECIALIDADE IN VARCHAR
                                       ,IN_CD_INTEGRACAO    IN NUMBER DEFAULT NULL
                                       ,IN_CD_ESPECIALIDADE IN NUMBER
                                       ,IN_NM_USR_CADASTRO  IN VARCHAR) AS
    BEGIN
        NULL;
    END PR_CADASTRA_ESPECIALIDADE;

    -------                                    
    PROCEDURE PR_CADASTRA_PROCEDIMENTO(IN_CD_PROCEDIMENTO IN NUMBER DEFAULT NULL
                                      ,IN_CD_ORIGEM       IN NUMBER
                                      ,IN_NM_PROCEDIMENTO IN VARCHAR
                                      ,IN_CD_INTEGRACAO   IN NUMBER DEFAULT NULL
                                      ,IN_NM_USR_CADASTRO IN VARCHAR) AS
    BEGIN
        NULL;
    END PR_CADASTRA_PROCEDIMENTO;

    --------                       
    PROCEDURE PR_CADASTRA_PERIODO(IN_DT_MES_ANO_REF  IN DATE
                                 ,IN_DT_INICIAL      IN DATE
                                 ,IN_DT_FINAL        IN DATE
                                 ,IN_DS_OBSERVACAO   IN VARCHAR DEFAULT NULL
                                 ,IN_NM_USR_CADASTRO IN VARCHAR) AS
    BEGIN
        NULL;
    END PR_CADASTRA_PERIODO;

    --------                       
    PROCEDURE PR_CADASTRA_FAIXA(IN_VL_FAIXA_INI    IN DATE
                               ,IN_VL_FAIXA_FIM    IN NUMBER
                               ,IN_VL_BONIFICACAO  IN NUMBER
                               ,IN_NM_USR_CADASTRO IN VARCHAR) AS
    BEGIN
        NULL;
    END PR_CADASTRA_FAIXA;

    --------
    PROCEDURE PR_CADASTRA_AVALIADO(IN_NM_USUARIO       IN VARCHAR
                                  ,IN_CD_INTEGRACAO    IN NUMBER DEFAULT NULL
                                  ,IN_NR_CRM           IN VARCHAR
                                  ,IN_CD_ESPECIALIDADE IN NUMBER
                                  ,IN_NM_USR_CADASTRO  IN VARCHAR) AS
    BEGIN
        NULL;
    END PR_CADASTRA_AVALIADO;

    --------       
    PROCEDURE PR_CADASTRA_DOMINIO(IN_NM_DOMINIO      IN VARCHAR
                                 ,IN_NR_PESO         IN NUMBER DEFAULT NULL
                                 ,IN_NM_USR_CADASTRO IN VARCHAR) AS
    BEGIN
        NULL;
    END PR_CADASTRA_DOMINIO;

    --------  
    PROCEDURE PR_CADASTRA_DIMENSAO(IN_NM_DIMENSAO     IN VARCHAR
                                  ,IN_NR_PESO         IN NUMBER DEFAULT NULL
                                  ,IN_NM_USR_CADASTRO IN VARCHAR) AS
    BEGIN
        NULL;
    END PR_CADASTRA_DIMENSAO;

    --------  
    PROCEDURE PR_CADASTRA_INDICADOR(IN_NM_INDICADOR    IN VARCHAR
                                   ,IN_NR_PESO         IN NUMBER DEFAULT NULL
                                   ,IN_DS_OBJETIVO     IN VARCHAR
                                   ,IN_NM_USR_CADASTRO IN VARCHAR) AS
    BEGIN
        NULL;
    END PR_CADASTRA_INDICADOR;

    --------  
    PROCEDURE PR_CADASTRA_RESTRICAO(IN_DS_RESTRICAO    IN VARCHAR
                                   ,IN_DS_OBSERVACAO   IN NUMBER DEFAULT NULL
                                   ,IN_NM_USR_CADASTRO IN VARCHAR) AS
    BEGIN
        NULL;
    END PR_CADASTRA_RESTRICAO;

    --------   
    PROCEDURE PR_CALCULA_EVS_AVAL_MES(IN_NR_SEQ_PERIODO IN NUMBER) AS
    BEGIN
        NULL;
    END PR_CALCULA_EVS_AVAL_MES;

    --------              
    PROCEDURE PR_CALCULA_EVS_AVAL_ANO(IN_NR_SEQ_PERIODO IN NUMBER) AS
    BEGIN
        NULL;
    END PR_CALCULA_EVS_AVAL_ANO;

    --------              
    PROCEDURE PR_CALCULA_EVS_ESP_MES(IN_NR_SEQ_PERIODO IN NUMBER) AS
    BEGIN
        NULL;
    END PR_CALCULA_EVS_ESP_MES;

    --------              
    PROCEDURE PR_CALCULA_EVS_ESP_ANO(IN_NR_SEQ_PERIODO IN NUMBER) AS
    BEGIN
        NULL;
    END PR_CALCULA_EVS_ESP_ANO;

    --------              
    ----
    ----
    ----GRAVAR LOGS------------------------
    PROCEDURE GRAVA_LOG(IN_NM_OBJ        IN VARCHAR
                       ,IN_FL_ERRO       IN CHAR DEFAULT 'N'
                       ,IN_DS_ERRM       IN VARCHAR DEFAULT NULL
                       ,IN_DS_LOG        IN VARCHAR
                       ,IN_JSON          IN CLOB
                       ,IN_DS_PARAMETROS IN VARCHAR DEFAULT 'SEM PARAMETROS'
                       ,OUT_SEQ_LOG      OUT NUMBER) AS
        V_SEQ_LOG       NUMBER;
        V_DS_PARAMETROS VARCHAR(4000);
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        BEGIN
            SELECT GLOBAL_NAME INTO PV_INSTANCE FROM GLOBAL_NAME;
            SELECT REPLACE(IN_DS_PARAMETROS, '\N', CHR(10))
              INTO V_DS_PARAMETROS
              FROM DUAL;
            SELECT NVL(MAX(L.SEQ_LOG), 0) + 1
              INTO V_SEQ_LOG
              FROM LOG_PCK_EVS L;
            OUT_SEQ_LOG := V_SEQ_LOG;
            INSERT INTO LOG_PCK_EVS
                (SEQ_LOG
                ,NM_OBJETO
                ,FL_ERRO
                ,DS_ERRM
                ,DS_LOG
                ,DS_JSON
                ,DS_PARAMETROS)
            VALUES
                (V_SEQ_LOG
                ,IN_NM_OBJ
                ,IN_FL_ERRO
                ,IN_DS_ERRM
                ,IN_DS_LOG
                ,IN_JSON
                ,V_DS_PARAMETROS);
            --
            COMMIT;
        END;
    END GRAVA_LOG;

END PCK_EVS;
/
