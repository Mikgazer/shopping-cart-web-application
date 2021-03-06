<%@page session="false"%>
<%@page import="model.mo.User"%>
<%@ page import="model.mo.Fumetto" %>
<%@ page import="java.util.List" %>
<%@ page import="java.io.File" %>
<%@ page import="model.mo.ContenutoNelMagazzino" %>
<%@ page import="model.mo.FornitoDa" %>
<%@ page import="java.util.HashMap" %>

<% int i;

    boolean loggedOn = (Boolean) request.getAttribute("loggedOn");
    User loggedUser = (User) request.getAttribute("loggedUser");

    String menuActiveLink = "Products";

    String applicationMessage = (String) request.getAttribute("applicationMessage");

    List<Fumetto> fumetti = (List<Fumetto>) request.getAttribute("fumetti");
    List<ContenutoNelMagazzino> contenutoNelMagazzinoArrayList = (List<ContenutoNelMagazzino>) request.getAttribute("contenutoNelMagazzinoArrayList");
    List<FornitoDa> fornitoDaArrayList = (List<FornitoDa>) request.getAttribute("fornitoDaArrayList");
    HashMap<String,File> fileImagesNamesHashMap = (HashMap<String,File>) request.getAttribute("fileImagesNamesHashMap");

%>

<!DOCTYPE html>
<html>
<head>
	<%@include file="/include/htmlHead.inc"%>
	<title>
		FumettiDB: <%=menuActiveLink%>
	</title>
	<style>

		#newProduct {
			float: right;
			margin-bottom: 10px;
		}

		#delete, #block, #addToCart, #viewDetails, #viewDetails, #unblock, #modify {
		}

		#addToCart {
			margin-left: 12px;
		}

		input[id=searchString] {
			background-color: white;
			background-position: 10px 10px;
			background-repeat: no-repeat;
			padding-left: 5px;
		}

		#fumetti {
			margin-top: 15px;
		}

		/*
      article {
          border: 1px solid #42424229;
          border-radius: 5px;
      }
      */

		#prodotti {
			text-align: center;
			float:left;
			height: 300px;
			width: 199px;
			margin: 10px 10px 10px 10px;

		}

		.titolo, .autore, .numero {
			font-size: 0.8em;
			text-align: center;
		}

		.additionalInfo {
			font-size: 0.5em;
		}

		<%if((loggedOn)&&(loggedUser.getAdmin().equals("Y"))){%>
		#productFrame {
			 margin-top: -20px;
		}
		<%} else if((!loggedOn)||(!((loggedUser.getAdmin().equals("Y"))))){%>
      #productFrame {
          margin-top: -20px;
      }
		<%}%>

	</style>
	<script lang="JavaScript">

		function insertProduct(){
			document.insertProductForm.submit();
		}

		function modifyProduct(ISBN){
			const f = document.modifyForm;
			f.ISBN.value = ISBN;
			f.submit();
		}

		function blockProduct(ISBN){
			const f = document.blockForm;
			f.ISBN.value = ISBN;
			f.submit();
		}

		function unblockProduct(ISBN){
			const f = document.unblockForm;
			f.ISBN.value = ISBN;
			f.submit();
		}

		function deleteProduct(ISBN){
			const f = document.deleteForm;
			f.ISBN.value = ISBN;
			f.submit();
		}

		function addToCart(ISBN){
			const f = document.addToCartForm;
			f.ISBN.value = ISBN;
			f.submit();
		}

		function viewDetails(ISBN){
			const f = document.viewDetailsForm;
			f.ISBN.value = ISBN;
			f.submit();
		}

		function mainOnLoadHandler(){
			 document.getElementById("searchImage").addEventListener("click",search);
		}

		window.addEventListener("load",mainOnLoadHandler);
	</script>
</head>
<body>
	<%@include file="/include/header.inc"%>
	<main>
		<%if((loggedOn)&&(loggedUser.getAdmin().equals("Y"))){%>
		<aside>
			<a href="javascript:insertProduct()">
				<img id="newProduct" alt="newProduct" src="images/add_book_icon.png" width="50" height="50" >
			</a>
		</aside>
		<%}%>
		<section id="pageTitle">
			<h1> Prodotti </h1>
		</section>

		<label for="searchString">
			<input type="text" id="searchString" name="searchString" maxlength="20"> </br>
		</label>

		<section id="searchMode" style="margin-top: 3px; margin-bottom: 2px">
			<input type="radio" id="Titolo" name="searchMode" value="Titolo"/>
				<label for="Titolo">Titolo</label>
			<input type="radio" id="Autore" name="searchMode" value="Autore"/>
				<label for="Autore">Autore</label>
			<input type="radio" id="Numero" name="searchMode" value="Numero"/>
				<label for="Numero">Numero</label>
		</section>

		<script lang="javascript">

			function search(){
				 let s = document.getElementById("searchString").value;
				 let opt = document.querySelector('input[name="searchMode"]:checked');
				 if(opt)
					  opt=opt.getAttribute('value');
				 const f = document.searchForm;
				 f.searchString.value = s;
				 f.searchMode.value = opt;
				 f.submit();
			}

			</script>
			<section style="margin-top: 3px;">
				<a onclick="window.search()">
					<img alt="search" id="searchImage" src="images/search.png" width="22" height="22">
				</a>
			</section>

		<section id="fumetti" class="clearfix">
			<% for(i=0; i<fumetti.size(); i++) {%>
			<article id ="prodotti">
				<section id="productFrameIcons">
					<%if(loggedOn){%>
						<%if(contenutoNelMagazzinoArrayList.get(i).getQuantita()>0){ %>
						<a href="javascript:addToCart(<%=fumetti.get(i).getISBN()%>)">
							<img alt="addToCart" id="addToCart" src="images/cart_plus.png" width="22" height="22"/>
						</a>
						<%}%>
					<%}%>
					<a href="javascript:viewDetails(<%=fumetti.get(i).getISBN()%>)">
						<img alt="viewDetails" id="viewDetails" src="images/details.png" width="22" height="22"/>
					</a>
					<%if((loggedOn)&&loggedUser.getAdmin().equals("Y")){%>
					<a href="javascript:blockProduct(<%=fumetti.get(i).getISBN()%>)">
						<img alt="block" id="block" src="images/block_icon.png" width="22" height="22"/>
					</a>
					<a href="javascript:unblockProduct(<%=fumetti.get(i).getISBN()%>)">
						<img alt="block" id="unblock" src="images/unblock.png" width="22" height="22"/>
					</a>
					<a href="javascript:modifyProduct(<%=fumetti.get(i).getISBN()%>)">
						<img alt="modify" id="modify" src="images/modify.png" width="22" height="22"/>
					</a>
					<a href="javascript:deleteProduct(<%=fumetti.get(i).getISBN()%>)">
						<img alt="delete" id="delete" src="images/trashcan.png" width="22" height="22"/>
					</a>
					<% } %>
				</section>
				<br>
				<div id="productFrame">
					<section class="titolo"> <%=fumetti.get(i).getTitolo()%> - <%=fumetti.get(i).getNumero()%></section>
					<section class="autore"> <%=fumetti.get(i).getAutore()%></section>
					<section class="numero"> <%=fumetti.get(i).getPrezzo()%> &euro;</section>
					<section style="margin-top: 5px" <%if(contenutoNelMagazzinoArrayList.get(i).getQuantita()==0){%>class="notAvailable"<%}%>>
						<a href="javascript:viewDetails(<%=fumetti.get(i).getISBN()%>)">
							<img id="prodotto" alt="<%=fumetti.get(i).getISBN()%>" src="productImages/<%=fumetti.get(i).getISBN()%>.jpg" width="150" height="215">
						</a>
					</section>
				</div>

			</article>
			<% } %>
		</section>

		<form name="insertProductForm" method="post" action="Dispatcher">
			<input type="hidden" name=""/>
			<input type="hidden" name="controllerAction" value="ProductsManagement.insertView"/>
		</form>
		<form name="addToCartForm" method="post" action="Dispatcher">
			<input type="hidden" name="ISBN"/>
			<input type="hidden" name="controllerAction" value="ProductsManagement.addToCart"/>
		</form>
		<form name="blockForm" method="post" action="Dispatcher">
			<input type="hidden" name="ISBN"/>
			<input type="hidden" name="controllerAction" value="ProductsManagement.block"/>
		</form>
		<form name="unblockForm" method="post" action="Dispatcher">
			<input type="hidden" name="ISBN"/>
			<input type="hidden" name="controllerAction" value="ProductsManagement.unblock"/>
		</form>
		<form name="deleteForm" method="post" action="Dispatcher">
			<input type="hidden" name="ISBN"/>
			<input type="hidden" name="nomeMagazzino" value="QD Magazzino">
			<input type="hidden" name="controllerAction" value="ProductsManagement.delete"/>
		</form>
		<form name="modifyForm" method="post" action="Dispatcher">
			<input type="hidden" name="ISBN"/>
			<input type="hidden" name="nomeFornitore" value="Quinta Dimensione"/>
			<input type="hidden" name="nomeMagazzino" value="QD Magazzino"/>
			<input type="hidden" name="controllerAction" value="ProductsManagement.modifyView"/>
		</form>
		<form name="viewDetailsForm" method="post" action="Dispatcher">
			<input type="hidden" name="ISBN"/>
			<input type="hidden" name="nomeFornitore" value="Quinta Dimensione"/>
			<input type="hidden" name="nomeMagazzino" value="QD Magazzino"/>
			<input type="hidden" name="controllerAction" value="ProductsManagement.viewDetails"/>
		</form>
		<form name="searchForm" method="post" action="Dispatcher">
			<input type="hidden" name="searchString"/>
			<input type="hidden" name="searchMode"/>
			<input type="hidden" name="controllerAction" value="ProductsManagement.view"/>
		</form>

	</main>
	<%@include file="/include/footer.inc"%>
</body>
</html>
