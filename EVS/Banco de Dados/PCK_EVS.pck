CREATE OR REPLACE PACKAGE EVS.PCK_EVS IS

    /***********************************************************************************************************************************************************************
    * Autor: Giulianno Ferrari Iervolino
    * Sistema: EVS
    * Objetivo: ENCAPSULAR OBJETOS UTILIZADOS PELO EVS
    *
    * Alterações :
    * |---------------------------------------------------------------------------------------------------------------------------------------------------------------------
    * | DATA         | RESPONSAVEL         | TICKET/CARD  | ALTERACAO
    * |--------------+------------------+----------------+-----------------------------------------------------------------------------------------------------------------
    * | 30/09/2022   | Giulianno Iervolino |   14738      | CRIAÇÃO DO OBJETO
    * |--------------+------------------+-----------------+-----------------------------------------------------------------------------------------------------------------     *
    ************************************************************************************************************************************************************************/
    --PROCEDURES CHAMADAS POR APIs
    V_INSTANCE VARCHAR2(40);

    --
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
    ---
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
