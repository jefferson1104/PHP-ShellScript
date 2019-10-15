<?php

    //recebimento o arquivo do upload
    $arquivo = $_FILES["log"]["tmp_name"];
    $nome = $_FILES["log"]["name"];

    //Pasta onde o arquivo vai ser salvo
    $_UP['pasta'] = 'temp/';

    //verificação da extensão do arquivo e condição para salvar o arquivo
    $ext = explode(".", $nome);
    $ext[0]; //nome do arquivo sem a extensão
    $extensao = end($ext);//extensão do arquivo
        
    if($extensao != "log") {
        echo "Extensão inválida";
    }else{

        //nome original do arquivo
        $nome_final = $_FILES["log"]["name"];

        // Depois verifica se é possível mover o arquivo para a pasta escolhida
        if (move_uploaded_file($_FILES['log']['tmp_name'], $_UP['pasta'] . $nome_final)) {
            //Upload efetuado com sucesso, exibe uma mensagem e um link para o arquivo
            //echo "Upload efetuado com sucesso!";
            //echo '<a href="' . $_UP['pasta'] . $nome_final . '">Clique aqui para acessar o arquivo</a>';
        } else {
            // Não foi possível fazer o upload, provavelmente a pasta está incorreta
            echo "Não foi possível enviar o arquivo, tente novamente";
        }

        //shellscript executando o parser no log e criando o arquivo csv tratado
        $comando  = "./EOSParser.sh temp/".$nome_final." temp/".$ext[0].".csv";
        $retorno = system("$comando");
        //echo $retorno;


        //nome do arquivo csv para passar via get
        $arquivocsv = $ext[0].".csv";
        ?>
            <script>
                setTimeout(function() {
                    window.location.assign("http://localhost/PHP-ShellScript/view.php?dados=<?php echo $arquivocsv;?>");
                }, 1000);          
            </script>
        <?php
    }
?>