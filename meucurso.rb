<? 
require_once("../config/bib_abreconexao.php"); 
require_once("../config/bib_configuracoes_seo.php");

session_start();       
$sessao_ativa = isset($_SESSION['idu']);
if ($sessao_ativa) { $link_back = 'entrada.php'; }else{ $link_back = 'entrada_livre.php'; }
$usu_id = $_SESSION['idu'];
$usu = $_SESSION['usuario'];
$seu_nome = $_SESSION['nome'];
$nu = $_SESSION['nu'];
//echo $usu_id.$nu;  
$msg = isset($_GET["msg"]) ? addslashes(trim($_GET["msg"])) : FALSE;   

$p = 1; 
if(isset($_GET['p'])){
// recupera variáveis
$p = sqlinj($_GET['p']);
}
$qnt = 10;

if(isset($_GET['p']))
{
    if ($p > 0 && is_numeric($p) ) { $p = $_GET["p"]; } else { $p = 1; }
    $inicio = ($p - 1) * $qnt;
}
else
{
    $inicio = 0;
    $p = 1;
}  
$altera = $cn->query("SET NAMES utf8");
$sql_select = "SELECT * FROM mensagem WHERE (id_destinatario='$usu_id' and tipo_destinatario='$nu' and id_tipo_grupo=0) or (tipo_destinatario=0 and id_tipo_grupo='$nu' and verificada=1) or (verificada=1 and id_destinatario=0 and tipo_destinatario=0 and id_tipo_grupo=0) ORDER BY data_envio DESC LIMIT $inicio, $qnt";
$sql_query = $cn->query($sql_select);

$sql_select_all = "SELECT * FROM mensagem WHERE (id_destinatario='$usu_id' and tipo_destinatario='$nu' and id_tipo_grupo=0) or (tipo_destinatario=0 and id_tipo_grupo='$nu' and verificada=1) or (verificada=1 and id_destinatario=0 and tipo_destinatario=0 and id_tipo_grupo=0) ";
$sql_query_all = $cn->query($sql_select_all);
$total_registros = $cn->num_rows($sql_query_all);
$pags = ceil($total_registros/$qnt);
$max_links = 3;
if($nu==1){  
//pegando responsaveis 
$sql_select_r = "SELECT * FROM aluno_responsavel as ar LEFT JOIN responsavel as r ON ar.id_responsavel = r.login WHERE id_aluno=$usu";
$sql_query_r = $cn->query($sql_select_r);
$total_registros_r = $cn->num_rows($sql_query_r); 
}
if($nu==2){  
//pegando alunos dos responsaveis 
$sql_select_r = "SELECT * FROM aluno_responsavel as ar LEFT JOIN aluno as a ON ar.id_aluno = a.login WHERE ar.id_responsavel=$usu";
$sql_query_r = $cn->query($sql_select_r);
$total_registros_r = $cn->num_rows($sql_query_r); 
}

if($nu==3 or $nu==4){ 
$sql_select_ap = "SELECT * FROM mensagem WHERE (tipo_destinatario='0' and id_destinatario='0' and verificada='0' and id_tipo_grupo!='0') ";
$sql_query_ap = $cn->query($sql_select_ap);
$total_registros_ap = $cn->num_rows($sql_query_ap);
}

?> 
 
<!DOCTYPE html> 
<html> 
    <head>
    <meta charset="UTF-8">    
    <title>Sagrado.Mobile</title> 
    
    <meta name="viewport" content="width=device-width, initial-scale=1.0 maximum-scale=1, user-scalable=no"> 
    <link rel="stylesheet" href="jquery.mobile.structure-1.0.1.css" />
    <link rel="apple-touch-icon" href="images/launch_icon_57.png" />
    <link rel="apple-touch-icon" sizes="72x72" href="images/launch_icon_72.png" />
    <link rel="apple-touch-icon" sizes="114x114" href="images/launch_icon_114.png" />
    <link rel="stylesheet" href="jquery.mobile-1.0.1.css" />
    <link rel="stylesheet" href="custom.css" />
    <script src="js/jquery-1.7.1.min.js"></script>
    <script src="js/jquery.mobile-1.0.1.min2.js"></script>   
    
    <script src="js/sm.js"></script>   
    <script type="text/javascript">
    $(document).ready(function() {
        $('input[type="file"]').textinput({theme: 'c'});   
        
        
    });
</script>                                                       
</head> 

<body> 
<div data-role="page" id="home" data-theme="d">
        <div id="topo" data-role="header">
            <h1>Sagrado.Mobile</h1>
	        <a href="<? echo $link_back; ?>" data-icon="back" class="ui-btn-left" data-transition="slidedown">Início</a> 
        </div>
    <div data-role="content">   
	 
	<div class="choice_list"> 
	<h2>Mensagens</h2>
	<? if($msg){echo '<p class="msg-alert">'.$msg.'</p>';} ?> 
   <div data-role="collapsible" data-theme="b" data-content-theme="d" data-iconpos="right">
   <h3>Enviar Mensagem</h3>
   <p>Preencha os campos e clique em enviar.</p>	
<div data-role="fieldcontain" class="ui-hide-label"> 
    <form action="enviarmsg.php" method="post" id="enviarmsg" enctype="multipart/form-data" data-transition="pop" data-ajax="false">
    <label for="de">De:</label>
    <input type="text" name="de" id="de" value="<? echo $seu_nome.' - '.$usu; ?>" class="ui-disabled"/> 
    <div id="inputs-alunos">
        <label>Filtrable with data-filter-placeholder css and optgroups</label>
                        <select class="flags" data-filter-placeholder="Search country" data-filter="true"
                            data-native-menu="false" id="Address_Country" name="Address.Country">
                            <option>Select a country</option>
                            <optgroup label="Most used countries">
                                <option class="DE" value="1">Germany</option>
                                <option class="US" value="2">United States</option>
                                <option class="GB" value="3">United Kingdom</option>
                                <option class="RO" value="4">Romania</option>
                                <option class="AT" value="5">Austria</option>
                            </optgroup>
                            <optgroup label='A'>
                                <option class="AF" value="6">Afghanistan</option>
                                <option class="AL" value="7">Albania</option>
                                <option class="DZ" value="8">Algeria</option>
                                <option class="AS" value="9">American Samoa</option>
                                <option class="AD" value="10">Andorra</option>
                                <option class="AO" value="11">Angola</option>
                                <option class="AI" value="12">Anguilla</option>
                                <option class="AG" value="13">Antigua &amp; Barbuda</option>
                                <option class="AN" value="14">Antilles, Netherlands</option>
                                <option class="AR" value="15">Argentina</option>
                                <option class="AM" value="16">Armenia</option>
                                <option class="AW" value="17">Aruba</option>
                                <option class="AU" value="18">Australia</option>
                                <option class="AZ" value="20">Azerbaijan</option>
                            </optgroup>
                            <optgroup label='B'>
                                <option class="BS" value="21">Bahamas, The</option>
                                <option class="BH" value="22">Bahrain</option>
                                <option class="BD" value="23">Bangladesh</option>
                                <option class="BB" value="24">Barbados</option>
                                <option class="BY" value="25">Belarus</option>
                                <option class="BE" value="26">Belgium</option>
                                <option class="BZ" value="27">Belize</option>
                                <option class="BJ" value="28">Benin</option>
                                <option class="BM" value="29">Bermuda</option>
                                <option class="BT" value="30">Bhutan</option>
                                <option class="BO" value="31">Bolivia</option>
                                <option class="BA" value="32">Bosnia and Herzegovina</option>
                                <option class="BW" value="33">Botswana</option>
                                <option class="BR" value="34">Brazil</option>
                                <option class="VG" value="35">British Virgin Islands</option>
                                <option class="BN" value="36">Brunei Darussalam</option>
                                <option class="BG" value="37">Bulgaria</option>
                                <option class="BF" value="38">Burkina Faso</option>
                                <option class="BI" value="39">Burundi</option>
                            </optgroup>
                            <optgroup label='C'>
                                <option class="KH" value="40">Cambodia</option>
                                <option class="CM" value="41">Cameroon</option>
                                <option class="CA" value="42">Canada</option>
                                <option class="CV" value="43">Cape Verde</option>
                                <option class="KY" value="44">Cayman Islands</option>
                                <option class="CF" value="45">Central African Republic</option>
                                <option class="TD" value="46">Chad</option>
                                <option class="CL" value="47">Chile</option>
                                <option class="CN" value="48">China</option>
                                <option class="CO" value="49">Colombia</option>
                                <option class="KM" value="50">Comoros</option>
                                <option class="CG" value="51">Congo</option>
                                <option class="CD" value="52">Congo</option>
                                <option class="CK" value="53">Cook Islands</option>
                                <option class="CR" value="54">Costa Rica</option>
                                <option class="CI" value="55">Cote D&#39;Ivoire</option>
                                <option class="HR" value="56">Croatia</option>
                                <option class="CU" value="57">Cuba</option>
                                <option class="CY" value="58">Cyprus</option>
                                <option class="CZ" value="59">Czech Republic</option>
                            </optgroup>
                            <optgroup label='D'>
                                <option class="DK" value="60">Denmark</option>
                                <option class="DJ" value="61">Djibouti</option>
                                <option class="DM" value="62">Dominica</option>
                                <option class="DO" value="63">Dominican Republic</option>
                            </optgroup>
                            <optgroup label='E'>
                                <option class="TP" value="64">East Timor (Timor-Leste)</option>
                                <option class="EC" value="65">Ecuador</option>
                                <option class="EG" value="66">Egypt</option>
                                <option class="SV" value="67">El Salvador</option>
                                <option class="GQ" value="68">Equatorial Guinea</option>
                                <option class="ER" value="69">Eritrea</option>
                                <option class="EE" value="70">Estonia</option>
                                <option class="ET" value="71">Ethiopia</option>
                            </optgroup>
                            <optgroup label='F'>
                                <option class="FO" value="73">Faroe Islands</option>
                                <option class="FJ" value="74">Fiji</option>
                                <option class="FI" value="75">Finland</option>
                                <option class="FR" value="76">France</option>
                                <option class="PF" value="78">French Polynesia</option>
                            </optgroup>
                            <optgroup label='G'>
                                <option class="GA" value="79">Gabon</option>
                                <option class="GM" value="80">Gambia, the</option>
                                <option class="GE" value="81">Georgia</option>
                                <option class="GH" value="83">Ghana</option>
                                <option class="GI" value="84">Gibraltar</option>
                                <option class="GR" value="85">Greece</option>
                                <option class="GL" value="86">Greenland</option>
                                <option class="GD" value="87">Grenada</option>
                                <option class="GP" value="88">Guadeloupe</option>
                                <option class="GU" value="89">Guam</option>
                                <option class="GT" value="90">Guatemala</option>
                                <option class="GG" value="91">Guernsey and Alderney</option>
                                <option class="GN" value="92">Guinea</option>
                                <option class="GW" value="93">Guinea-Bissau</option>
                                <option class="GP" value="94">Guinea, Equatorial</option>
                                <option class="GY" value="96">Guyana</option>
                            </optgroup>
                            <optgroup label='H'>
                                <option class="HT" value="97">Haiti</option>
                                <option class="HN" value="99">Honduras</option>
                                <option class="HK" value="100">Hong Kong, (China)</option>
                                <option class="HU" value="101">Hungary</option>
                            </optgroup>
                            <optgroup label='I'>
                                <option class="IS" value="102">Iceland</option>
                                <option class="IN" value="103">India</option>
                                <option class="ID" value="104">Indonesia</option>
                                <option class="IR" value="105">Iran, Islamic Republic of</option>
                                <option class="IQ" value="106">Iraq</option>
                                <option class="IE" value="107">Ireland</option>
                                <option class="IL" value="108">Israel</option>
                                <option class="CI" value="109">Ivory Coast (Cote d&#39;Ivoire)</option>
                                <option class="IT" value="110">Italy</option>
                            </optgroup>
                            <optgroup label='J'>
                                <option class="JM" value="111">Jamaica</option>
                                <option class="JP" value="112">Japan</option>
                                <option class="JE" value="113">Jersey</option>
                                <option class="JO" value="114">Jordan</option>
                            </optgroup>
                            <optgroup label='K'>
                                <option class="KZ" value="115">Kazakhstan</option>
                                <option class="KE" value="116">Kenya</option>
                                <option class="KI" value="117">Kiribati</option>
                                <option class="KR" value="118">Korea, (South) Rep. of</option>
                                <option class="KW" value="119">Kuwait</option>
                                <option class="KG" value="120">Kyrgyzstan</option>
                            </optgroup>
                            <optgroup label='L'>
                                <option class="LA" value="121">Lao People&#39;s Dem. Rep.</option>
                                <option class="LV" value="122">Latvia</option>
                                <option class="LB" value="123">Lebanon</option>
                                <option class="LS" value="124">Lesotho</option>
                                <option class="LY" value="125">Libyan Arab Jamahiriya</option>
                                <option class="LI" value="126">Liechtenstein</option>
                                <option class="LT" value="127">Lithuania</option>
                                <option class="LU" value="128">Luxembourg</option>
                            </optgroup>
                            <optgroup label='M'>
                                <option class="MO" value="129">Macao, (China)</option>
                                <option class="MK" value="130">Macedonia, TFYR</option>
                                <option class="MG" value="131">Madagascar</option>
                                <option class="MW" value="132">Malawi</option>
                                <option class="MY" value="133">Malaysia</option>
                                <option class="MV" value="134">Maldives</option>
                                <option class="ML" value="135">Mali</option>
                                <option class="MT" value="136">Malta</option>
                                <option class="MQ" value="137">Martinique</option>
                                <option class="MR" value="138">Mauritania</option>
                                <option class="MU" value="139">Mauritius</option>
                                <option class="MX" value="140">Mexico</option>
                                <option class="FM" value="141">Micronesia</option>
                                <option class="MD" value="142">Moldova, Republic of</option>
                                <option class="MC" value="143">Monaco</option>
                                <option class="MN" value="144">Mongolia</option>
                                <option class="MA" value="146">Morocco</option>
                                <option class="MZ" value="147">Mozambique</option>
                                <option class="MM" value="148">Myanmar (ex-Burma)</option>
                            </optgroup>
                            <optgroup label='N'>
                                <option class="NA" value="149">Namibia</option>
                                <option class="NP" value="150">Nepal</option>
                                <option class="NL" value="151">Netherlands</option>
                                <option class="NC" value="152">New Caledonia</option>
                                <option class="NZ" value="153">New Zealand</option>
                                <option class="NI" value="154">Nicaragua</option>
                                <option class="NE" value="155">Niger</option>
                                <option class="NG" value="156">Nigeria</option>
                                <option class="NO" value="158">Norway</option>
                            </optgroup>
                            <optgroup label='O'>
                                <option class="OM" value="159">Oman</option>
                            </optgroup>
                            <optgroup label='P'>
                                <option class="PK" value="160">Pakistan</option>
                                <option class="PS" value="161">Palestinian Territory</option>
                                <option class="PA" value="162">Panama</option>
                                <option class="PG" value="163">Papua New Guinea</option>
                                <option class="PY" value="164">Paraguay</option>
                                <option class="PE" value="165">Peru</option>
                                <option class="PH" value="166">Philippines</option>
                                <option class="PL" value="167">Poland</option>
                                <option class="PT" value="168">Portugal</option>
                            </optgroup>
                            <optgroup label='Q'>
                                <option class="QA" value="170">Qatar</option>
                            </optgroup>
                            <optgroup label='R'>
                                <option class="RE" value="172">Reunion</option>
                                <option class="RU" value="173">Russian Federation</option>
                                <option class="RW" value="174">Rwanda</option>
                            </optgroup>
                            <optgroup label='S'>
                                <option class="KN" value="175">Saint Kitts and Nevis</option>
                                <option class="LC" value="176">Saint Lucia</option>
                                <option class="VC" value="177">St. Vincent &amp; the Grenad.</option>
                                <option class="WS" value="178">Samoa</option>
                                <option class="SM" value="179">San Marino</option>
                                <option class="ST" value="180">Sao Tome and Principe</option>
                                <option class="SA" value="181">Saudi Arabia</option>
                                <option class="SN" value="182">Senegal</option>
                                <option class="RS" value="183">Serbia</option>
                                <option class="SC" value="184">Seychelles</option>
                                <option class="SG" value="185">Singapore</option>
                                <option class="SK" value="186">Slovakia</option>
                                <option class="SI" value="187">Slovenia</option>
                                <option class="SB" value="188">Solomon Islands</option>
                                <option class="SO" value="189">Somalia</option>
                                <option class="ES" value="190">Spain</option>
                                <option class="LK" value="191">Sri Lanka (ex-Ceilan)</option>
                                <option class="SD" value="192">Sudan</option>
                                <option class="SR" value="193">Suriname</option>
                                <option class="SZ" value="194">Swaziland</option>
                                <option class="SE" value="195">Sweden</option>
                                <option class="CH" value="196">Switzerland</option>
                                <option class="SY" value="197">Syrian Arab Republic</option>
                            </optgroup>
                            <optgroup label='T'>
                                <option class="TW" value="198">Taiwan</option>
                                <option class="TJ" value="199">Tajikistan</option>
                                <option class="TZ" value="200">Tanzania, United Rep. of</option>
                                <option class="TH" value="201">Thailand</option>
                                <option class="TG" value="202">Togo</option>
                                <option class="TO" value="203">Tonga</option>
                                <option class="TT" value="204">Trinidad &amp; Tobago</option>
                                <option class="TN" value="205">Tunisia</option>
                                <option class="TR" value="206">Turkey</option>
                                <option class="TM" value="207">Turkmenistan</option>
                            </optgroup>
                            <optgroup label='U'>
                                <option class="UG" value="208">Uganda</option>
                                <option class="UA" value="209">Ukraine</option>
                                <option class="AE" value="210">United Arab Emirates</option>
                                <option class="UY" value="211">Uruguay</option>
                                <option class="UZ" value="212">Uzbekistan</option>
                            </optgroup>
                            <optgroup label='V'>
                                <option class="VU" value="213">Vanuatu</option>
                                <option class="VE" value="214">Venezuela</option>
                                <option class="VN" value="215">Viet Nam</option>
                                <option class="VI" value="216">Virgin Islands, U.S.</option>
                            </optgroup>
                            <optgroup label='Y'>
                                <option class="YE" value="217">Yemen</option>
                            </optgroup>
                            <optgroup label='Z'>
                                <option class="ZM" value="218">Zambia</option>
                                <option class="ZW" value="219">Zimbabwe</option>
                            </optgroup>
                        </select>
    </div>
    <select id="para" data-native-menu="false" name="para">
<option data-placeholder="true">Para:</option> 
<? 
if($nu==1){ 
//verifica se não existe registros
if ($total_registros_r == 0) {
     //sem responsaveis
}
else {
    
    echo '<optgroup label="Responsáveis">';

    while($array2 = $cn->fetch_array($sql_query_r)) {
        echo '<option  value='.$array2['id'].'>'.$array2['nome'].'</option>';
    }
    echo '</optgroup>';
}
}   
if($nu==2){ 
//verifica se não existe registros
if ($total_registros_r == 0) {
     //sem responsaveis
}
else {
    
    echo '<optgroup label="Alunos (Filho(a)s)">';

    while($array3 = $cn->fetch_array($sql_query_r)) {
        echo '<option  value='.$array3['id'].'>'.$array3['nome'].'</option>';
    }
    echo '</optgroup>';
}
}   
?>


<optgroup label="Grupos">
<option value="todos">Todos os Usuários</option>
<option value="alunos">Alunos</option>
<option value="pais">Pais e Responsáveis</option>
<option value="professores">Professores</option>
<option value="funcionarios">Direção e Funcionários</option>
<option value="pastoral">Pastoral Educacional</option>  
</optgroup>
</select>     
    <label for="titulo">Título*:</label>
    <input type="text" name="titulo" id="titulo" value=""  placeholder="Título*"/> 
    <label for="mensagem">Mensagem:</label>
	<textarea name="mensagem" id="mensagem" placeholder="Mensagem"></textarea>
	<div> <p>Escolha uma foto:</p>
        <input type="file" name="img" id="img" />
</div>
<div class="ui-body" > 
                        <div class="ui-grid-a">
                            <div class="ui-block-a"><button type="reset" >Limpar</button></div>
                            <div class="ui-block-b"><button type="submit" data-theme="b" id="logar">Enviar</button></div>
                        </div>
                  </div>    
                  </form>
</div>

<p>* Campos Obrigatórios</p>
</div>   
<h3>Suas Mensagens</h3>	
   <?
//verifica se não existe registros
if ($total_registros == 0) {
     //mensagem se não existe nenhum cadastro
    echo '<p>Sem mensagens para você.</p>';
}
else {
    
    echo '<ul data-role="listview" data-inset="true" >';

    while($array = $cn->fetch_array($sql_query)) {
        echo '<li><a href="mensagem.php?id='.$array['id'].'" data-transition="slide"><h2>'.$array['titulo'].'</h2> <p class="classement four">'.$array['data_envio'].'</p></a></li>';
    }
    
    echo '</ul>'; 
    
    if ($pags > 1){
    
    echo '<div class="bloco-navegacao" style="text-align: center;"><div data-role="controlgroup" data-type="horizontal">';
    echo '<a data-role="button" data-icon="arrow-l" href="mensagens.php?p=1">Primeira</a>';
    for($i = $p-$max_links; $i <= $p-1; $i++) {
        if($i <= 0) {
        
        } 
        else {
             
            echo '<a data-role="button" href="mensagens.php?p='.$i.'" >'.$i.'</a>'; 
        }
    }
    echo '<a data-role="button" data-theme="b" href="#">'.$p.'</a> ';

    for($i = $p+1; $i <= $p+$max_links; $i++) {
        if($i > $pags){
        
        }
        else{
           
                echo '<a data-role="button" href="mensagens.php?p='.$i.'" >'.$i.'</a>'; 
            
        }
    }
    echo '<a data-role="button" data-icon="arrow-r" href="mensagens.php?p='.$pags.'">Última</a>';
    
    echo '</div>'; 
    
    }
    
}        
        ?>       
 

<?
if($nu==3 or $nu==4){ 

//verifica se não existe registros
if ($total_registros_ap == 0) {
     //mensagem se não existe nenhum cadastro
    
}
else 
{
    
    echo '<h3>Mensagens Aguardando Aprovação</h3>';
    echo '<ul data-role="listview" data-inset="true" >';
    while($array4 = $cn->fetch_array($sql_query_ap)) {
        echo '<li><a href="mensagem.php?id='.$array4['id'].'" data-transition="slide"><h2>'.$array4['titulo'].'</h2> <p class="classement four">'.$array4['data_envio'].'</p></a></li>';
    }
    echo '</ul>';   
}

}   
?> 
	</div>
	</div>

</div><!-- /page -->        
<? include("../_incs/ga.php"); ?> 
</body>
</html>