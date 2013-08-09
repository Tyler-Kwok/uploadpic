package com.production;

import java.util.Locale;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.production.bean.ProductTestBean;

@Controller
@RequestMapping(value = "/production")
@SessionAttributes({ "productbean", "pbid" })
public class ProductionController {
	@Autowired
	ServletContext context;
	static String filepath = "/resources/pics";
	private Map<UUID, ProductTestBean> products = new ConcurrentHashMap<UUID, ProductTestBean>();
	private Logger logger = LoggerFactory.getLogger(ProductionController.class);

	@RequestMapping(value = "/fancybox-modal-popup", method = RequestMethod.GET)
	public ModelAndView getImages(HttpServletRequest request) {

		ModelAndView model = new ModelAndView("fancybox-modal-popup");
		model
		    .addObject(
		        "jsonData",
		        "[{\"name\":\"add1\",\"id\":\"adId1\"},{\"name\":\"add2\",\"id\":\"adId2\"},{\"name\":\"add3\",\"id\":\"adId3\"},{\"name\":\"add4\",\"id\":\"adId4\"}]");

		return model;
	}

	@RequestMapping(value = "/submitMessage", method = RequestMethod.POST)
	public @ResponseBody
	String submitMessage(@RequestParam String message, @RequestParam String email) throws Exception {
		System.out.println(message);
		System.out.println(email);
		if (message != null && !"".equals(message) && email != null && !"".equals(email)) {
			return "{\"success\":true, \"msg\":\"submit success!\"}";
		} else {
			return "{\"success\":false, \"msg\":\"submit fail!\"}";
		}
	}

	/**
	 * 
	 * @param productId
	 * @param request
	 * @param locale
	 * @param model
	 * @return productId back to the SUCCESS clause in ajax call, and then pass
	 *         this id to contact_us.jsp page.
	 */
	@RequestMapping(value = "/modal-popup-contact-us/{productId}", method = RequestMethod.POST)
	public @ResponseBody
	Integer popupContactUs(@PathVariable("productId") String productId, HttpServletRequest request, Locale locale, Model model) {
		logger.debug(" =======popupContactUs========productId: " + productId);
		return Integer.parseInt(productId);

	}

	@RequestMapping(value = "/createproduct", method = RequestMethod.POST)
	public String submitProduct(HttpServletRequest req, Model model, @ModelAttribute("product") ProductTestBean product) {
		UUID pbid = product.getPbid();

		if (products.containsKey(pbid)) {

			product.setMpf(products.get(pbid).getMpf());
		}
		logger.info("------submit production------" + pbid.toString());
		logger.info(product.printProductBean());
		req.getSession().removeAttribute("productbean");
		req.getSession().removeAttribute("pbid");
		model.addAttribute("message", "success");
		return "production/addedresult";
	}

	public ProductTestBean createbean() {
		ProductTestBean productbean = new ProductTestBean(context.getRealPath(filepath));
		products.put(productbean.assignID(), productbean);
		return productbean;
	}
}
