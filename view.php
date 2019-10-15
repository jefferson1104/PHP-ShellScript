<?php
    $arquivocsv = $_REQUEST['dados'];
?>

<!DOCTYPE html>
<html lang="pt-br">
  <head>
    <!-- Meta tags Obrigatórias -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">

    <!-- font awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/css/all.css" rel="stylesheet" type="text/css">
    
    <title>Visualizar dados</title>
  </head>
  <body>

  <?php require "menu.php"; ?>
  
  <div class="container mb-3 mt-3">

        <div class="row justify-content-center">
            <div class=" col-6 mt-2">
                <h2 class="text-center">Visualizar dados <i class="fas fa-table"></i></h2>
                <hr>
            </div>
        </div>

        <div class="row justify-content-center">
            <table class="table table-sm table-bordered table-hover table-dark" style="width: 100%" id="minhaTabela">

                <tbody>

                <?php
                $objeto = fopen("shellscript/temp/$arquivocsv", "r");
                while (($dados = fgetcsv($objeto, 1000, ";")) !== FALSE) {

                    $eos            =   utf8_encode($dados[0]);
                    $oba            =   utf8_encode($dados[1]);
                    $rc             =   utf8_encode($dados[2]);
                    $iroute         =   utf8_encode($dados[3]);
                    $oroute         =   utf8_encode($dados[4]);
                    $stype          =   utf8_encode($dados[5]);
                    $tmrprimeused   =   utf8_encode($dados[6]);
                    $tmrprimevalid  =   utf8_encode($dados[7]);
                    $origrouting    =   utf8_encode($dados[8]);
                    $bnrlastpos     =   utf8_encode($dados[9]);
                    $ema            =   utf8_encode($dados[10]);
                    $anumber        =   utf8_encode($dados[11]);
                    $bnumber        =   utf8_encode($dados[12]);
                    ?>        
                               
                    <tr>
                        <td><?php echo $eos; ?></td>
                        <td><?php echo $oba; ?></td>
                        <td><?php echo $rc; ?></td>
                        <td><?php echo $iroute; ?></td>
                        <td><?php echo $oroute; ?></td>
                        <td><?php echo $stype; ?></td>
                        <td><?php echo $tmrprimeused; ?></td>
                        <td><?php echo $tmrprimevalid; ?></td>
                        <td><?php echo $origrouting; ?></td>
                        <td><?php echo $bnrlastpos; ?></td>
                        <td><?php echo $ema; ?></td>
                        <td><?php echo $anumber; ?></td>
                        <td><?php echo $bnumber; ?></td>
                    </tr>
                    <?php } ?>
                </tbody>
            </table> 
        </div><!-- end row -->

    </div> <!-- end container -->

    <!-- JavaScript (Opcional) -->
    <!-- jQuery primeiro, depois Popper.js, depois Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
  
  </body>
</html>


<?php
    //deletando arquivo log carregado
    $explodearquivo = explode(".", $arquivocsv);
    $arquivolog = $explodearquivo[0].".log";
    $deletar_log = unlink("shellscript/temp/".$arquivolog);
    echo $deletar_log;

    //deletando arquivo csv gerado
    $deletar_csv = unlink("shellscript/temp/".$arquivocsv);
    echo $deletar_csv;
?>